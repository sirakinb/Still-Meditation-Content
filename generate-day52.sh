#!/bin/bash
# Generate Day 52 slides: "The silence challenge — 15 minutes with no input" (CHALLENGE)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day52"

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

# Slide 1 — Hook (the challenge)
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in a quiet meditation pose, headphones removed and resting on the floor beside him, phone face-down nearby, calm focused expression, soft warm natural light.
Large bold left-aligned headline text at the top reads: THE SILENCE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: CHALLENGE.
Line 2: 15 minutes."

# Slide 2 — What it is
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with a calm grounded expression, arms relaxed at his sides, eyes open looking forward.
Large bold left-aligned headline text at the top reads: NO INPUT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: No music.
Line 2: No podcast.
Line 3: No phone."

# Slide 3 — Step 1: pick a time
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands calmly, one hand thoughtfully at his chin, quietly determined expression.
Large bold left-aligned headline text at the top reads: STEP 1
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: Pick a time.
Line 2: Tonight or
Line 3: tomorrow."

# Slide 4 — Step 2: do it
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot walks slowly outdoors on a soft natural path, calm relaxed expression, soft warm light.
Large bold left-aligned headline text at the top reads: STEP 2
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: Sit or walk.
Line 2: 15 minutes.
Line 3: That is it."

# Slide 5 — What comes up
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged with a calm composed expression, eyes softly open, weathering inner restlessness with steadiness.
Large bold left-aligned headline text at the top reads: WHAT ARISES
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: Boredom.
Line 2: Restlessness.
Line 3: Then space."

# Slide 6 — Why it matters
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands strong and grounded with a small confident smile, soft warm light behind him.
Large bold left-aligned headline text at the top reads: WHY IT MATTERS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on THREE lines:
Line 1: Builds your
Line 2: self-directed
Line 3: practice muscle."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a small reassuring smile, arms relaxed at his sides, soft warm glow around him, in the bottom half of the image only.
At the top in large bold left-aligned text: ACCEPT THE CHALLENGE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Just you.
Line 2: Just silence.
At the bottom in bold smaller text: Follow @stillmeditation for Day 53
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

# Slide 7 — IG variant
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a small reassuring smile, arms relaxed at his sides, soft warm glow around him, in the bottom half of the image only.
At the top in large bold left-aligned text: ACCEPT THE CHALLENGE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Just you.
Line 2: Just silence.
At the bottom in bold smaller text: Follow @stillmeditation.app for Day 53
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

echo ""
echo "=== Day 52 Complete ==="
