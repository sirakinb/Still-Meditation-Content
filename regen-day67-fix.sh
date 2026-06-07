#!/bin/bash
# Regen Day 67 broken slides: slide3 (typo), slide7_instagram ([CRLF] artifacts)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day67"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm zen meditation room with wooden floors, soft natural light, green plants — UNLESS the scene calls for another setting. DO NOT include any text branding or logo anywhere. DO NOT draw any internal frames, borders, mini-cards, or picture-in-picture elements — the mascot is part of the same single scene as the text. Light warm background with rounded corners on the OUTER card only. Text should be bold, large, left-aligned, and highly readable for mobile viewing. Spell every word correctly. 4:5 portrait orientation. Only ONE instance of the mascot per image."

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
    echo "Aborting — fix the API issue before retrying." >&2
    exit 1
  fi

  data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data')
  if [ -z "$data" ] || [ "$data" = "null" ]; then
    echo "✗ Slide ${slide_num} FAILED: no image data in response" >&2
    echo "Full response:" >&2
    echo "$response" | head -c 800 >&2
    echo "" >&2
    exit 1
  fi

  echo "$data" | base64 -d > "$filename"

  size=$(stat -f%z "$filename" 2>/dev/null || stat -c%s "$filename")
  if [ "$size" -lt 10000 ]; then
    echo "✗ Slide ${slide_num} FAILED: output file is only ${size} bytes" >&2
    exit 1
  fi
  echo "✓ Slide ${slide_num} saved (${size} bytes)"
}

# Slide 3 — The test (regen: fix spelling of "immune response")
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands firm and calm, chest open, steady composed expression, soft warm light.
Large bold left-aligned headline text at the top reads: THE TEST
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text, EXACTLY these lines spelled correctly:
Participants were injected
with bacterial endotoxin.
Their immune response
was measured.
CRITICAL SPELLING: The word 'immune' must be spelled i-m-m-u-n-e. The word 'response' must be spelled r-e-s-p-o-n-s-e. Do NOT distort, merge, or misspell any word."

# Slide 7_instagram — CTA IG variant (regen: remove [CRLF] artifacts, correct handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with chest open, arms slightly wide, strong and healthy expression, warm vibrant light around him.
Large bold left-aligned headline text at the top reads EXACTLY: BREATHE. HEAL.
These are two separate words on two lines. Do NOT insert any codes, brackets, or escape sequences. Just the words BREATHE. and HEAL. on separate lines.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text EXACTLY: Your immune system is listening.
Do NOT insert [CRLF] or any bracket codes anywhere. Only plain readable words.
At the bottom in bold text: Follow @stillmeditation.app for Day 68
The username MUST be spelled exactly: @stillmeditation.app (one word with .app at the end, do NOT duplicate any letters or add codes)"

echo ""
echo "=== Day 67 Regen Pass 1 Complete ==="
