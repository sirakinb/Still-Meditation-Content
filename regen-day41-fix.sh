#!/bin/bash
# Regenerate Day 41 broken slides (slide4 duplicated "Find where", slide7 duplicated "Every wave")
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day41"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm zen meditation room with wooden floors, soft natural light, green plants. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

generate_slide() {
  local slide_num=$1
  local prompt=$2
  local filename="${OUTPUT_DIR}/slide${slide_num}.png"

  echo "Generating Slide ${slide_num}..."
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

# Slide 4 — Step 2: LOCATE IT (shorter, no repeating words to avoid Gemini dup bug)
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits with one hand on his chest and the other on his stomach, eyes softly closed, attentive listening expression.
Render the text EXACTLY as written below, no extra words, no repetition.
Large bold left-aligned headline text at the top reads exactly: STEP 2: LOCATE IT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text render exactly these three short lines and nothing else:
Tight chest.
Heavy stomach.
Where does it live?"

# Slide 7 — TikTok CTA (rewrite to avoid the 'every wave' repetition that confused Gemini)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident with a calm half-smile, both hands relaxed at his sides, soft warm light around him.
Render the text EXACTLY as written below, no extra words, no repetition.
Large bold left-aligned headline text at the top reads exactly: SIT WITH IT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text render exactly these three short lines and nothing else:
Waves crest.
Waves fall.
You're still here.
At the bottom in bold text render exactly: Follow @stillmeditation for Day 42"

echo ""
echo "=== Day 41 regen complete ==="
