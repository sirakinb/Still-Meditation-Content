#!/bin/bash
# Generate Day 50 slides: "Advanced meditators feel peaceful all the time" — MYTH
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day50"

mkdir -p "$OUTPUT_DIR"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm zen meditation room with wooden floors, soft natural light, green plants — UNLESS the scene calls for another setting. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

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
    echo "$response" | head -c 600 >&2
    exit 1
  fi
  echo "$data" | base64 -d > "$filename"
  size=$(stat -f%z "$filename" 2>/dev/null || stat -c%s "$filename")
  if [ "$size" -lt 10000 ]; then
    echo "✗ Slide ${slide_num} FAILED: file only ${size} bytes" >&2
    exit 1
  fi
  echo "✓ Slide ${slide_num} saved (${size} bytes)"
}

# Slide 1 — Hook (the myth)
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in meditation pose, eyes calm and softly open, a small knowing smile, soft warm natural light.
Large bold left-aligned headline text at the top reads: THE BIGGEST MYTH ABOUT MEDITATION
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Advanced meditators
Line 2: feel peaceful 24/7."

# Slide 2 — The truth
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged, eyes softly open, a calm grounded expression, soft warm light.
Large bold left-aligned headline text at the top reads: THE TRUTH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: They feel everything.
Line 2: They just don't
Line 3: drown in it."

# Slide 3 — Beginner reaction
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged with a slightly frustrated expression, a small storm cloud above his head, soft warm light.
Large bold left-aligned headline text at the top reads: BEGINNERS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: Anger arises.
Line 2: You become
Line 3: the anger."

# Slide 4 — Advanced reaction
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged with a calm grounded expression, watching a small cloud float past in the distance, soft warm light.
Large bold left-aligned headline text at the top reads: ADVANCED
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: Anger arises.
Line 2: You watch it
Line 3: and let it pass."

# Slide 5 — The skill
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall with a calm grounded posture, hand on chest in a gesture of presence, a soft confident smile.
Large bold left-aligned headline text at the top reads: THE SKILL
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: Notice it.
Line 2: Feel it fully.
Line 3: Let it move through."

# Slide 6 — The science
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall with arms relaxed, a confident knowing smile, soft warm glow.
Large bold left-aligned headline text at the top reads: THE SCIENCE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: Meditation widens
Line 2: the gap between
Line 3: feeling and reacting."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a small reassuring smile, soft warm glow around him, in the bottom half of the image only.
At the top in large bold left-aligned text: STOP CHASING CALM.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Practice noticing.
Line 2: Practice letting go.
At the bottom in bold smaller text: Follow @stillmeditation for Day 51
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

# Slide 7 — IG variant
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a small reassuring smile, soft warm glow around him, in the bottom half of the image only.
At the top in large bold left-aligned text: STOP CHASING CALM.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Practice noticing.
Line 2: Practice letting go.
At the bottom in bold smaller text: Follow @stillmeditation.app for Day 51
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

echo ""
echo "=== Day 50 Complete ==="
