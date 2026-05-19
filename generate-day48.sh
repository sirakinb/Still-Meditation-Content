#!/bin/bash
# Generate Day 48 slides: "Kapalabhati: the skull-shining breath" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day48"

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

# Slide 1 — Hook
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and energized, eyes alert and bright, one hand raised in a small confident gesture, soft warm natural light around him, an energetic posture.
Large bold left-aligned headline text at the top reads: 90 SECONDS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Skip the coffee.
Try this ancient
breathing trick."

# Slide 2 — What it is
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with arms relaxed at his sides, calm focused expression, soft warm light, peaceful but alert.
Large bold left-aligned headline text at the top reads: KAPALABHATI
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Sanskrit for
skull-shining breath.
Three thousand years old."

# Slide 3 — Step 1: POSTURE
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright cross-legged in meditation, spine tall and straight, hands resting on his knees, eyes softly open with a focused gaze.
Large bold left-aligned headline text at the top reads: STEP 1: SIT TALL
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Spine straight.
Hands on knees.
Take one slow breath."

# Slide 4 — Step 2: THE EXHALE
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in meditation pose with one hand resting on his belly, a focused energized expression, soft natural light, mouth gently closed.
Large bold left-aligned headline text at the top reads: STEP 2: PUMP IT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Short sharp exhales
through the nose.
Belly snaps inward."

# Slide 5 — Step 3: PASSIVE INHALE
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in meditation, calm relaxed expression, belly soft and natural, eyes peacefully open with a steady gaze.
Large bold left-aligned headline text at the top reads: STEP 3: LET GO
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Do not force inhales.
The belly releases.
Air rushes in on its own."

# Slide 6 — The dose
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with arms relaxed and a calm confident expression, looking forward, soft warm glow.
Large bold left-aligned headline text at the top reads: THE DOSE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Twenty pumps.
Rest. Repeat once.
Ninety seconds total."

# Slide 7 — Safety + CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a small reassuring smile, soft warm glow around him, in the bottom half of the image only.
At the top in large bold left-aligned text: SAFETY FIRST.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Skip if pregnant,
Line 2: high BP, or panic.
At the bottom in bold smaller text: Follow @stillmeditation for Day 49
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

# Slide 7 — IG variant
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a small reassuring smile, soft warm glow around him, in the bottom half of the image only.
At the top in large bold left-aligned text: SAFETY FIRST.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Skip if pregnant,
Line 2: high BP, or panic.
At the bottom in bold smaller text: Follow @stillmeditation.app for Day 49
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

echo ""
echo "=== Day 48 Complete ==="
