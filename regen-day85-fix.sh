#!/bin/bash
# Regen Day 85 broken slides: slide2 (nested card artifact), slide7_instagram (handle typo)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day85"

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

# Slide 2 — The Framework (regen: remove nested card artifact)
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
CRITICAL: The mascot must be drawn DIRECTLY on the card background — NOT inside any inner frame, inner card, or secondary rounded rectangle. There is only ONE outer card border. The mascot and text are part of the same unified scene with no dividers or sub-frames.
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone. The mascot is drawn directly on the warm background.
The scene: The mascot sits in meditation pose, one hand on chest, one in lap, peaceful grounded expression.
Large bold left-aligned headline text at the top reads: THE FRAMEWORK
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Every strong daily
practice has 3 pillars:
Ground. Heart. Awareness."

# Slide 7_instagram — CTA IG variant (regen: fix handle typo)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident with a calm proud smile, arms relaxed, soft warm light around him, a sense of arrival and ownership.
Large bold left-aligned headline text at the top reads: YOUR PRACTICE.
YOUR WAY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You have the tools.
Now build the ritual.
At the bottom in bold text, EXACTLY these words spelled correctly: Follow @stillmeditation.app for Day 86
IMPORTANT: The username MUST be spelled exactly: @stillmeditation.app — that is s-t-i-l-l-m-e-d-i-t-a-t-i-o-n dot app. Do NOT spell it as stilmeditation or stillmeditation or any other variation. Two L's in still."

echo ""
echo "=== Day 85 Regen Complete ==="
