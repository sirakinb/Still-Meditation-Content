#!/bin/bash
# Generate Day 68 slides: "Choiceless awareness: the most advanced basic skill" (TUTORIAL)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day68"

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
The scene: The mascot sits cross-legged in a calm meditation pose, eyes softly open and relaxed, a curious gentle expression, soft warm light around him.
Large bold left-aligned headline text at the top reads: WHAT IF YOU DIDN'T CHOOSE?
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The most advanced
meditation skill
is also the simplest."

# Slide 2 — What it is
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits calmly with a peaceful open expression, soft natural light.
Large bold left-aligned headline text at the top reads: CHOICELESS AWARENESS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You stop directing attention.
You let it move
on its own."

# Slide 3 — Step 1
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged, eyes softly closed, hands resting on knees, calm mid-breath, soft warm light.
Large bold left-aligned headline text at the top reads: STEP 1
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Begin with the breath.
Three minutes.
Just follow each inhale."

# Slide 4 — Step 2
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits relaxed, shoulders loose, a serene letting-go expression, soft natural light.
Large bold left-aligned headline text at the top reads: STEP 2
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Release all choosing.
Stop steering.
Let attention go free."

# Slide 5 — Step 3
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits calmly, head tilted slightly as if noticing something, gentle curious expression, soft light.
Large bold left-aligned headline text at the top reads: STEP 3
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Follow whatever is loudest.
A sound. A thought.
A sensation."

# Slide 6 — The image
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in deep calm meditation, peaceful expression, a soft glowing warm light gently moving around him.
Large bold left-aligned headline text at the top reads: LIKE A SPOTLIGHT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: When one fades,
the next takes its place.
The light moves on its own."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in serene meditation, eyes softly closed, deeply at peace, warm vibrant light around him.
Large bold left-aligned headline text at the top reads: LET GO OF THE WHEEL.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Awareness knows
where to go.
At the bottom in bold text: Follow @stillmeditation for Day 69"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in serene meditation, eyes softly closed, deeply at peace, warm vibrant light around him.
Large bold left-aligned headline text at the top reads: LET GO OF THE WHEEL.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Awareness knows
where to go.
At the bottom in bold text: Follow @stillmeditation.app for Day 69"

echo ""
echo "=== Day 68 Complete ==="
