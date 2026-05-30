#!/bin/bash
# Regen Day 59 fixes:
#   slide6  — body text was truncated ("This is" cut off)
#   slide7  — word duplication ("this this sit")
#   slide7_instagram — handle broke into "@stillmeditation .app" with a space
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day59"

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

# Slide 6 — Min 15–20: Rest (shorter body so it doesn't truncate)
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits completely still in a deeply relaxed pose, eyes softly closed, a peaceful expression of pure rest.
Render exactly this text, no additions, no truncation.
Large bold left-aligned ALL-CAPS section header at the top reads: MIN 15–20: REST
LEAVE A CLEAR GAP between header and body.
Below in medium bold text exactly:
Stop doing.
Rest in what is here.
This is the whole point."

# Slide 7 — TikTok variant (no duplicated words)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with a quiet confident half-smile, both hands open and relaxed at his sides, soft golden light around him.
Render exactly this text, no additions, no repeated words.
Large bold left-aligned headline text at the top reads: 20 MINUTES.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text exactly:
You have built to this.
Do it today.
At the bottom in bold text exactly: Follow @stillmeditation for Day 60"

# Slide 7 — Instagram variant (keep handle as a single unbroken token)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with a quiet confident half-smile, both hands open and relaxed at his sides, soft golden light around him.
Render exactly this text, no additions, no repeated words.
Large bold left-aligned headline text at the top reads: 20 MINUTES.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text exactly:
You have built to this.
Do it today.
At the bottom in bold text exactly the following on ONE line with NO space inside the handle: Follow @stillmeditation.app for Day 60
The handle @stillmeditation.app must be written as one continuous token with a single period between stillmeditation and app — never break it across lines, never insert a space."

echo ""
echo "=== Day 59 Regen Complete ==="
