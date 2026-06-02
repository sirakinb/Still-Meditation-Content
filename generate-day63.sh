#!/bin/bash
# Generate Day 63 slides: "You need a teacher to meditate properly" — MYTH-BUSTING
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day63"

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
The scene: The mascot stands with arms open and a confident, welcoming smile, calm and self-assured posture, soft warm light.
Large bold left-aligned headline text at the top reads: YOU NEED A TEACHER?
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Myth.
Apps, teachers, or solo —
here is the real answer."

# Slide 2 — The myth
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits cross-legged in meditation pose, thoughtful expression, one hand raised as if questioning.
Large bold left-aligned headline text at the top reads: THE MYTH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Ancient traditions
required years under
a guru's guidance.
Most of us lack that."

# Slide 3 — What teachers offer
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands in a wise, open posture, gentle nodding expression, one hand out in a teaching gesture.
Large bold left-aligned headline text at the top reads: TEACHERS OFFER
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Personalized feedback.
Real accountability.
Centuries of lineage."

# Slide 4 — What apps offer
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits comfortably cross-legged, relaxed and content expression, soft ambient glow around him.
Large bold left-aligned headline text at the top reads: APPS OFFER
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Consistency. Access.
Privacy. Guidance
at 3am when you need it."

# Slide 5 — What solo builds
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot meditates alone in stillness, eyes gently closed, serene independent posture, hands resting on knees.
Large bold left-aligned headline text at the top reads: SOLO BUILDS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: True independence.
You learn your own
mind — no crutch needed."

# Slide 6 — The research + real answer
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall and balanced, calm knowing smile, arms loosely at sides, grounded confident stance.
Large bold left-aligned headline text at the top reads: THE REAL ANSWER
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: All three. Different
stages. Right now —
you are building self-direction."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, soft warm light around him.
Large bold left-aligned headline text at the top reads: YOUR PRACTICE IS VALID.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: No guru required.
No app required.
Just you and the breath.
At the bottom in bold text: Follow @stillmeditation for Day 64"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, soft warm light around him.
Large bold left-aligned headline text at the top reads: YOUR PRACTICE IS VALID.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: No guru required.
No app required.
Just you and the breath.
At the bottom in bold text: Follow @stillmeditation.app for Day 64"

echo ""
echo "=== Day 63 Complete ==="
