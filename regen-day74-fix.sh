#!/bin/bash
# Regen Day 74 broken slides: 2, 4, 5, 7_instagram
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day74"

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

# Slide 2 — Regen: remove nested card artifact
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
IMPORTANT: The mascot and the text MUST exist in the same single unified scene. Do NOT create an inner card, inner rectangle, or any bordered box behind the text. Everything is part of one card with ONE outer rounded border only.
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands calm and composed, one hand resting on his chest, the other open at his side. Zen meditation room background with wooden floors and plants.
EXACTLY these lines spelled correctly:
Header (large bold): 7 STATES. 7 TOOLS.
LEAVE A CLEAR GAP between header and body.
Body (medium bold):
Most people use one breath
for everything.
These seven techniques are
each built for a specific state."

# Slide 4 — Regen: header must be "FOR FOCUS" not "ALL-CAPS FOR FOCUS"
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands upright, sharp and focused, shoulders squared, steady calm gaze, warrior energy.
EXACTLY these lines spelled correctly:
Header (large bold): FOR FOCUS
LEAVE A CLEAR GAP between header and body.
Body (medium bold):
Box breathing.
4 in. 4 hold.
4 out. 4 hold.
Repeat 4 rounds.
Used by Navy SEALs."

# Slide 5 — Regen: fix 'exhales' typo and reduce text to fit
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands energized and upright, forward-leaning confident posture, light radiating from his chest, wide awake expression.
EXACTLY these lines spelled correctly — the word is EXHALES not exkhales:
Header (large bold): FOR ENERGY
LEAVE A CLEAR GAP between header and body.
Body (medium bold):
Kapalabhati: rapid exhales.
30 pumps, full exhale hold.
Wim Hof: 30 power inhales.
Full exhale then hold.
Make sure ALL body text is fully visible and not cut off at the bottom of the card."

# Slide 7_instagram — Regen: handle must not be cut off
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, warm soft light around him in a zen meditation room.
EXACTLY these lines spelled correctly:
Headline (large bold): SAVE THIS. USE IT TONIGHT.
LEAVE A CLEAR GAP between headline and body.
Body (medium bold):
You now have seven tools.
Match the technique to the moment.
Screenshot this slide.
At the very bottom of the card in bold text, EXACTLY this text with NO letters cut off and NO letters missing: Follow @stillmeditation.app for Day 75
The username MUST be spelled exactly: @stillmeditation.app — the full word including .app must be completely visible and not cropped by the card edge."

echo ""
echo "=== Regen Day 74 Complete ==="
