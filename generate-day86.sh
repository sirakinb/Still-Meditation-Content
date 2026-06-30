#!/bin/bash
# Generate Day 86 slides: "The ripple effect: how your meditation practice affects others" (SCIENCE)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day86"

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
The scene: The mascot stands calm and centered in a warm meditation room, arms slightly open, radiating a soft gentle glow outward — suggesting energy emanating from him to those around him. Peaceful confident expression.
Large bold left-aligned headline text at the top reads: WHEN YOU MEDITATE,
THE PEOPLE AROUND YOU
CHANGE TOO.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Your calm is contagious.
Here is the science."

# Slide 2 — Co-regulation
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands calm and composed, one hand on his chest, soft steady expression.
Large bold left-aligned headline text at the top reads: CO-REGULATION
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Your nervous system
broadcasts a signal.
People nearby pick it up."

# Slide 3 — The science
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands in a calm neutral setting, thoughtful and grounded, soft warm light.
Large bold left-aligned headline text at the top reads: THE RESEARCH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Calm nervous systems
sync with those nearby.
Harvard calls it
physiological linkage."

# Slide 4 — Partners feel it
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands in a home setting, warm soft light, gentle calm presence.
Large bold left-aligned headline text at the top reads: PARTNERS FEEL IT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Partners of meditators
report feeling calmer.
Less conflict.
More ease at home."

# Slide 5 — At work
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands in a calm neutral environment, confident and grounded, steady expression.
Large bold left-aligned headline text at the top reads: AT WORK TOO
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Meditators improve
team dynamics.
One practitioner shifts
the whole group's stress."

# Slide 6 — The ripple
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation pose, eyes closed, peaceful and still, soft warm glow around him.
Large bold left-aligned headline text at the top reads: THE RIPPLE EFFECT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Your practice is not
just for you.
It radiates outward
to everyone you touch."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with arms slightly open, calm confident expression, soft warm glow radiating outward from his body.
Large bold left-aligned headline text at the top reads: YOUR CALM IS A GIFT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Practice for yourself.
Watch it reach everyone else.
At the bottom in bold text: Follow @stillmeditation for Day 87"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with arms slightly open, calm confident expression, soft warm glow radiating outward from his body.
Large bold left-aligned headline text at the top reads: YOUR CALM IS A GIFT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Practice for yourself.
Watch it reach everyone else.
At the bottom in bold text: Follow @stillmeditation.app for Day 87"

echo ""
echo "=== Day 86 Complete ==="
