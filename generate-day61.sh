#!/bin/bash
# Generate Day 61 slides: "Sitting with discomfort: the advanced skill nobody talks about" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day61"

mkdir -p "$OUTPUT_DIR"

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

# Slide 1 — Hook
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in deep meditation, eyes gently closed, hands resting on knees with calm unwavering posture, soft warm light washing over him.
Large bold left-aligned headline text at the top reads: MEDITATION GETS UNCOMFORTABLE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Don't move.
Don't quit.
Do this instead."

# Slide 2 — The mistake
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits with a slightly restless expression, one hand hovering as if about to adjust position, but catches himself — holds still with a knowing look.
Large bold left-aligned headline text at the top reads: THE MISTAKE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Most people shift,
fidget, or quit.
That trains your brain
to fear discomfort more."

# Slide 3 — Step 1: Locate It
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright in meditation, one hand resting on his knee, other hand gently pointing inward toward his own body, curious focused expression.
Large bold left-aligned headline text at the top reads: STEP 1: LOCATE IT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Where exactly is it?
Knee? Lower back?
Stomach? Get specific."

# Slide 4 — Step 2: Describe It
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with a thoughtful examining expression, head tilted slightly, one finger raised as if making a mental note, soft investigative gaze.
Large bold left-aligned headline text at the top reads: STEP 2: DESCRIBE IT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Shape? Temperature?
Dull or sharp?
Describe it — don't judge it."

# Slide 5 — Step 3: Watch It Change
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation, a calm amazed expression, hands open on knees, soft glow around him suggesting the sensation dissolving — peaceful stillness.
Large bold left-aligned headline text at the top reads: STEP 3: WATCH IT CHANGE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Sensations shift.
Pulse. Spread. Dissolve.
What seemed unbearable
fades under your gaze."

# Slide 6 — The Transfer
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with a calm powerful expression, both hands resting open on knees, grounded steady posture — radiating equanimity and quiet strength.
Large bold left-aligned headline text at the top reads: THE TRANSFER
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: This works for
emotional pain too.
Anxiety. Grief. Anger.
Examine it. Don't run."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and calm, arms relaxed at his sides, a steady confident expression — totally at ease, unshaken, fully present.
Large bold left-aligned headline text at the top reads: DISCOMFORT IS
THE DOORWAY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Sit with it.
Watch it change.
That is equanimity.
At the bottom in bold text: Follow @stillmeditation for Day 62"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and calm, arms relaxed at his sides, a steady confident expression — totally at ease, unshaken, fully present.
Large bold left-aligned headline text at the top reads: DISCOMFORT IS
THE DOORWAY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Sit with it.
Watch it change.
That is equanimity.
At the bottom in bold text: Follow @stillmeditation.app for Day 62"

echo ""
echo "=== Day 61 Complete ==="
