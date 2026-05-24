#!/bin/bash
# Generate Day 51 slides: "Open awareness — meditation without an anchor" (TUTORIAL)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day51"

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

# Slide 1 — Hook (the question)
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in meditation pose, eyes softly open in a gentle relaxed gaze, calm and curious expression, soft warm natural light, a hint of open sky visible through a window behind him.
Large bold left-aligned headline text at the top reads: TRY THIS TONIGHT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Meditate without
Line 2: an anchor."

# Slide 2 — What is it
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged with a calm open expression, eyes softly open looking outward, soft warm light.
Large bold left-aligned headline text at the top reads: OPEN AWARENESS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: No breath focus.
Line 2: No mantra.
Line 3: Just witness."

# Slide 3 — Step 1
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged with eyes closed, peaceful expression, hands resting on his knees, soft warm light.
Large bold left-aligned headline text at the top reads: STEP 1
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: Settle with
Line 2: the breath for
Line 3: 3 minutes."

# Slide 4 — Step 2
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged, eyes softly open, looking upward with a calm relaxed expression, a hint of bright open sky behind him.
Large bold left-aligned headline text at the top reads: STEP 2
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: Release the focus.
Line 2: Let awareness
Line 3: open like sky."

# Slide 5 — Clouds metaphor
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged with a serene expression, eyes softly open, small puffy clouds float gently past him in the background sky.
Large bold left-aligned headline text at the top reads: WHAT YOU NOTICE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: Sounds, sensations,
Line 2: thoughts arise
Line 3: and pass like clouds."

# Slide 6 — The rule
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged with a calm grounded smile, hands resting open and relaxed on his knees, soft warm light.
Large bold left-aligned headline text at the top reads: THE ONE RULE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: Don't grab.
Line 2: Don't push away.
Line 3: Just witness."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a small reassuring smile, soft warm glow around him, in the bottom half of the image only.
At the top in large bold left-aligned text: BECOME THE SKY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Not the weather.
Line 2: Not the clouds.
At the bottom in bold smaller text: Follow @stillmeditation for Day 52
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

# Slide 7 — IG variant
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a small reassuring smile, soft warm glow around him, in the bottom half of the image only.
At the top in large bold left-aligned text: BECOME THE SKY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Not the weather.
Line 2: Not the clouds.
At the bottom in bold smaller text: Follow @stillmeditation.app for Day 52
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

echo ""
echo "=== Day 51 Complete ==="
