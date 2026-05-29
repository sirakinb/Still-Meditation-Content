#!/bin/bash
# Regen broken Day 57 slides: 3 and 6
# Slide 3 had "ALL-CAPS SIGN 2" header + corrupted body
# Slide 6 had "SLL-CAPS" instead of "SIGN 5"
# Fix: remove the literal phrase "ALL-CAPS" from prompts; shorten body copy further
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day57"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm zen meditation room with wooden floors, soft natural light, green plants. DO NOT include any text branding or logo anywhere. DO NOT draw any internal frames, borders, mini-cards, or picture-in-picture elements — the mascot is part of the same single scene as the text. Light warm background with rounded corners on the OUTER card only. Text should be bold, large, left-aligned, and highly readable for mobile viewing. Spell every word correctly. 4:5 portrait orientation. Only ONE instance of the mascot per image."

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

# Slide 3 — Sign 2: notice tension early (shorter, cleaner)
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot rolls his shoulders slowly, eyes softly closed, a relaxed aware expression, gently noticing his body.
Render exactly this text and nothing else.
Large bold left-aligned header at the top reads only the two words: SIGN 2
LEAVE A CLEAR GAP between header and body.
Below in medium bold text, render exactly these four short lines:
You notice tension
before it becomes pain.
You feel it early.
You release it."

# Slide 6 — Sign 5: quiet confidence (shorter, cleaner)
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall and grounded, shoulders relaxed, a steady confident half-smile, soft warm glow around him.
Render exactly this text and nothing else.
Large bold left-aligned header at the top reads only the two words: SIGN 5
LEAVE A CLEAR GAP between header and body.
Below in medium bold text, render exactly these four short lines:
A quiet confidence.
You can handle
whatever comes.
No panic. Just calm."

echo ""
echo "=== Day 57 Regen Complete ==="
