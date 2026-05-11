#!/bin/bash
# Generate Day 40 slides: "Meditation is selfish" — MYTH-BUSTING
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day40"

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
The scene: The mascot stands confidently with arms crossed, calm knowing half-smile, looking straight ahead, soft warm light.
Large bold left-aligned headline text at the top reads: MEDITATION IS SELFISH?
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Wrong.
It's the most strategic
thing you can do."

# Slide 2 — The guilt setup
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits calmly, hand on his chest, peaceful but understanding expression.
Large bold left-aligned headline text at the top reads: THE GUILT TRAP
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You feel selfish
taking 10 minutes
while others need you.
Read on."

# Slide 3 — Oxygen mask
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright with calm grounded posture, one hand on his chest, focused steady gaze.
Large bold left-aligned headline text at the top reads: OXYGEN MASK RULE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Airlines say it first.
Help yourself before
you help anyone else."

# Slide 4 — Compassion research
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with an open warm posture, hand extended outward in a giving gesture, gentle expression.
Large bold left-aligned headline text at the top reads: THE RESEARCH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Meditators are
50% more likely
to help strangers."

# Slide 5 — Less reactive
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands calm and grounded with relaxed shoulders, soft steady expression, unshaken posture.
Large bold left-aligned headline text at the top reads: LESS REACTIVE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You snap less.
Listen more.
Forgive faster."

# Slide 6 — Loving-kindness trains generosity
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in meditation pose with a soft warm glow around his heart, peaceful happy expression.
Large bold left-aligned headline text at the top reads: TRAINED KINDNESS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Loving-kindness
practice literally
rewires generosity."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, soft warm light around him.
Large bold left-aligned headline text at the top reads: SIT. EVERYONE BENEFITS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 10 minutes for you.
A calmer you
for everyone else.
At the bottom in bold text: Follow @stillmeditation for Day 41"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, soft warm light around him.
Large bold left-aligned headline text at the top reads: SIT. EVERYONE BENEFITS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 10 minutes for you.
A calmer you
for everyone else.
At the bottom in bold text: Follow @stillmeditation.app for Day 41"

echo ""
echo "=== Day 40 Complete ==="
