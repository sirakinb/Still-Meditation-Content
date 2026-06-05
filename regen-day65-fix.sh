#!/bin/bash
# Regen broken slides for Day 65
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day65"

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
    exit 1
  fi

  data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data')
  if [ -z "$data" ] || [ "$data" = "null" ]; then
    echo "✗ Slide ${slide_num} FAILED: no image data in response" >&2
    echo "$response" | head -c 800 >&2
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

# Slide 2 — regen: mascot was overlapping final word "match" in left text zone
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
CRITICAL LAYOUT RULE: All text must be in the LEFT 55% of the card. The mascot MUST be placed entirely in the RIGHT 45%, with ZERO overlap into the text area. Keep the mascot narrow — do not let any part of the mascot cross the vertical center line.
The scene: The mascot stands upright with a calm knowing expression, arms at sides, soft ambient light.
Large bold left-aligned ALL-CAPS header text at the top reads: YOUR NERVOUS SYSTEM
LEAVE A CLEAR GAP between header and body.
Below in medium bold left-aligned text — EXACTLY these lines spelled correctly:
Morning: cortisol rising,
brain coming online.

Evening: cortisol dropping,
body winding down.

Practice should match
the direction."

# Slide 4 — regen: typo "rin" should be "min" in "10 to 15 min."
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
CRITICAL LAYOUT RULE: All text must be in the LEFT 55% of the card. The mascot MUST be placed entirely in the RIGHT 45%, with ZERO overlap into the text area.
The scene: The mascot sits cross-legged in a softly lit evening room, gentle moonlight, deeply relaxed and peaceful expression, eyes gently closed.
Large bold left-aligned ALL-CAPS header text at the top reads: EVENING PRACTICE
LEAVE A CLEAR GAP between header and body.
Below in medium bold left-aligned text — EXACTLY these lines spelled correctly (pay careful attention to every abbreviation):
Goal: deactivation.
Breathwork: 4-7-8 or
coherent (5-5) — 3 to 5 min.
Meditation: body scan or
loving-kindness — 10 to 15 min.
The word 'min' is spelled m-i-n. Do NOT write 'rin' or any other variation. Spell it EXACTLY: min"

echo ""
echo "=== Day 65 Regen Complete ==="
