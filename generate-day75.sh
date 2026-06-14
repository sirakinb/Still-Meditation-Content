#!/bin/bash
# Generate Day 75 slides: "Meditation means detaching from life" — MYTH-BUSTING
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day75"

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
The scene: The mascot stands with arms open wide, confident warm smile, engaged and fully present posture, as if embracing the world around him.
Large bold left-aligned headline text at the top reads: MEDITATION MAKES YOU DETACH?
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Myth.
It pulls you deeper
into life — not away."

# Slide 2 — The Fear
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands with a thoughtful, slightly concerned expression, one hand raised, as if voicing a worry.
Large bold left-aligned headline text at the top reads: THE FEAR
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: People worry they'll
become cold. Numb.
Unreachable. They won't."

# Slide 3 — Two Very Different Things
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot holds both hands open, palms up, balanced and calm, illustrating openness rather than walls.
Large bold left-aligned headline text at the top reads: TWO DIFFERENT THINGS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Detachment = walls up.
Non-attachment = open hands.
Meditation teaches the second."

# Slide 4 — You Feel More
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot has a wide genuine smile, one hand on his chest, eyes bright and open, radiating warmth and presence.
Large bold left-aligned headline text at the top reads: YOU FEEL MORE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Meditators report
deeper joy and more vivid
experiences — not fewer."

# Slide 5 — You Participate More
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands in an active, engaged posture — leaning slightly forward, alert and ready, grounded but present.
Large bold left-aligned headline text at the top reads: YOU PARTICIPATE MORE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Less hijacked by fear.
Less stuck in thought loops.
You show up fully."

# Slide 6 — The Reframe
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with a calm knowing smile, arms loosely at sides, clear steady gaze — composed and certain.
Large bold left-aligned headline text at the top reads: THE REFRAME
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Clinging distorts life.
Non-attachment lets you
see it clearly."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, soft warm light around him.
Large bold left-aligned headline text at the top reads: LIFE — BUT CLEARER.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You still love deeply.
You still feel fully.
You just stop white-knuckling outcomes.
At the bottom in bold text: Follow @stillmeditation for Day 76"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, soft warm light around him.
Large bold left-aligned headline text at the top reads: LIFE — BUT CLEARER.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You still love deeply.
You still feel fully.
You just stop white-knuckling outcomes.
At the bottom in bold text: Follow @stillmeditation.app for Day 76"

echo ""
echo "=== Day 75 Complete ==="
