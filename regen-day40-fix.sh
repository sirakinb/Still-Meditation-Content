#!/bin/bash
# Regenerate Day 40 broken slides (slide 3 had duplicated "Help", slide 7_instagram had duplicated "for")
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day40"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm zen meditation room with wooden floors, soft natural light, green plants — UNLESS the scene calls for another setting. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

generate_slide() {
  local slide_num=$1
  local prompt=$2
  local filename="${OUTPUT_DIR}/slide${slide_num}.png"

  echo "Regenerating Slide ${slide_num}..."
  response=$(curl -s -X POST "${ENDPOINT}" \
    -H "x-goog-api-key: ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{\"contents\":[{\"parts\":[{\"text\": $(echo "$prompt" | jq -Rs .)}]}],\"generationConfig\":{\"responseModalities\":[\"TEXT\",\"IMAGE\"]}}")

  err=$(echo "$response" | jq -r '.error.message // empty')
  if [ -n "$err" ]; then
    echo "✗ Slide ${slide_num} FAILED: $err" >&2
    exit 1
  fi

  data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data')
  if [ -z "$data" ] || [ "$data" = "null" ]; then
    echo "✗ Slide ${slide_num} FAILED: no image data" >&2
    exit 1
  fi

  echo "$data" | base64 -d > "$filename"
  size=$(stat -f%z "$filename" 2>/dev/null || stat -c%s "$filename")
  echo "✓ Slide ${slide_num} saved (${size} bytes)"
}

# Slide 3 — shorter body to avoid duplication
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright with a calm grounded posture, one hand on his chest, focused steady gaze.
Render EXACTLY this text and nothing else, with no repeated words, no duplicated words:
Headline at top (large bold, two lines): OXYGEN MASK RULE
Clear gap.
Body (medium bold, three short lines):
Airlines say it first.
Help yourself
before anyone else.
NO duplicated words. NO repeated words. Render each word only once."

# Slide 7_instagram — shorter body to avoid duplication
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, soft warm light around him.
Render EXACTLY this text and nothing else, with no repeated words, no duplicated words:
Headline at top (large bold, two lines): SIT. EVERYONE BENEFITS.
Clear gap.
Body (medium bold, three short lines):
10 minutes for you.
A calmer you.
Better for everyone.
Bottom line (bold): Follow @stillmeditation.app for Day 41
NO duplicated words. NO repeated words. Render each word only once. The handle must be exactly @stillmeditation.app — no extra letters."

echo ""
echo "=== Day 40 Regen Complete ==="
