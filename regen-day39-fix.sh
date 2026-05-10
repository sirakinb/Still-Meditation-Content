#!/bin/bash
# Regen Day 39 slides 3 and 7 (TikTok variant)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day39"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm zen meditation room with wooden floors, soft natural light, green plants. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

generate_slide() {
  local slide_num=$1
  local prompt=$2
  local filename="${OUTPUT_DIR}/slide${slide_num}.png"
  echo "Generating Slide ${slide_num}..."
  response=$(curl -s -X POST "${ENDPOINT}" \
    -H "x-goog-api-key: ${API_KEY}" -H "Content-Type: application/json" \
    -d "{\"contents\":[{\"parts\":[{\"text\": $(echo "$prompt" | jq -Rs .)}]}],\"generationConfig\":{\"responseModalities\":[\"TEXT\",\"IMAGE\"]}}")
  err=$(echo "$response" | jq -r '.error.message // empty')
  if [ -n "$err" ]; then echo "✗ Slide ${slide_num} FAILED: $err" >&2; exit 1; fi
  data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data')
  if [ -z "$data" ] || [ "$data" = "null" ]; then echo "✗ Slide ${slide_num} no image" >&2; exit 1; fi
  echo "$data" | base64 -d > "$filename"
  size=$(stat -f%z "$filename" 2>/dev/null || stat -c%s "$filename")
  if [ "$size" -lt 10000 ]; then echo "✗ Slide ${slide_num} only ${size} bytes" >&2; exit 1; fi
  echo "✓ Slide ${slide_num} saved (${size} bytes)"
}

# Slide 7 (TikTok) — clean prompt, no meta-instructions Gemini might render literally.
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, soft warm light around him.
Headline at the top, large bold left-aligned, two lines:
PICK ONE.
USE IT TODAY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text:
Calm. Focus.
Energy. Balance.
Save this post.
At the bottom in bold text: Follow @stillmeditation for Day 40"

echo ""
echo "=== Day 39 fixes complete ==="
