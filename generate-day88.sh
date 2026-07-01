#!/bin/bash
# Generate Day 88 slides: "What happens after 90 days" — MOTIVATION
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day88"

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
The scene: The mascot stands in a calm confident stance looking toward a bright open horizon, one hand gesturing forward, a hopeful settled expression, warm golden light suggesting a new beginning.
Large bold left-aligned headline text at the top reads: DAY 90 ISN'T
THE END.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: It's the beginning
of everything."

# Slide 2 — What you built
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits grounded and steady in meditation pose, calm and rooted, a sense of a solid foundation beneath him.
Large bold left-aligned headline text at the top reads: YOU BUILT A
FOUNDATION
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 90 days ago,
five minutes felt long.
Now stillness feels like home."

# Slide 3 — Your toolkit
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits calmly with a quietly confident expression, a sense of being well-equipped and capable, soft natural light.
Large bold left-aligned headline text at the top reads: 15+ TECHNIQUES
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Breath. Focus. Awareness.
A full toolkit,
ready whenever you need it."

# Slide 4 — 20 minutes
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in a long, still, unhurried meditation pose, eyes softly closed, completely at ease with time, calm morning light.
Large bold left-aligned headline text at the top reads: 20 MINUTES
OF STILLNESS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: What felt impossible
is now ordinary.
The mind learned to stay."

# Slide 5 — Difficult emotions
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits calm and steady, an expression of quiet composure amid a soft passing storm, unshaken, warm grounding light.
Large bold left-aligned headline text at the top reads: HARD EMOTIONS,
MET
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You don't run now.
You breathe. You watch.
They pass."

# Slide 6 — Depth has no ceiling
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in deep meditation looking upward toward vast open sky, a sense of endless space and unlimited depth above him, expansive light.
Large bold left-aligned headline text at the top reads: DEPTH HAS
NO CEILING
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The foundation is set.
Everything from here
is going deeper."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and grounded, calm confident smile, both hands relaxed at his sides, warm light around him — a sense of readiness for what comes next.
Large bold left-aligned headline text at the top reads: THIS IS THE
BEGINNING.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Keep sitting.
Keep going deeper.
At the bottom in bold text: Follow @stillmeditation for Day 89"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and grounded, calm confident smile, both hands relaxed at his sides, warm light around him — a sense of readiness for what comes next.
Large bold left-aligned headline text at the top reads: THIS IS THE
BEGINNING.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Keep sitting.
Keep going deeper.
At the bottom in bold text: Follow @stillmeditation.app for Day 89"

echo ""
echo "=== Day 88 Complete ==="
