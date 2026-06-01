#!/bin/bash
# Generate Day 62 slides: "Meditation and the default mode network" — SCIENCE
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day62"

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
The scene: The mascot sits cross-legged in calm meditation, eyes gently closed, a soft serene expression, warm light around him.
Large bold left-aligned headline text at the top reads: YOUR BRAIN HAS AN OVERTHINKING NETWORK.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Scientists found it.
Meditation quiets it."

# Slide 2 — Meet the DMN
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot taps the side of his own head with one finger, a curious thoughtful expression, as if pointing to his brain.
Large bold left-aligned headline text at the top reads: MEET THE DMN
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The Default Mode Network.
Your brain's idle channel.
Always running in the background."

# Slide 3 — When it fires
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with a distracted faraway look, gaze drifting upward, mind clearly wandering.
Large bold left-aligned headline text at the top reads: WHEN IT FIRES
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Mind-wandering.
Replaying the past.
Worrying about you."

# Slide 4 — The cost
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot rubs his temple with a slightly weary expression, caught in a loop of thought.
Large bold left-aligned headline text at the top reads: THE COST
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: An overactive DMN
means rumination,
anxiety, and a restless
monkey mind."

# Slide 5 — What meditation does
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in calm meditation, a peaceful settled expression, soft glow of stillness around him.
Large bold left-aligned headline text at the top reads: WHAT MEDITATION DOES
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: It quiets the DMN.
Less mind-wandering.
A calmer baseline."

# Slide 6 — The proof
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright with a calm confident expression, one hand resting on his knee, grounded and steady.
Large bold left-aligned headline text at the top reads: THE PROOF
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Yale, 2011.
Experienced meditators
showed less DMN activity
and faster recovery."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation, eyes gently closed, totally at peace, a quiet calm radiating from him.
Large bold left-aligned headline text at the top reads: QUIET THE NOISE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You can train the
network that overthinks.
One sit at a time.
At the bottom in bold text: Follow @stillmeditation for Day 63"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation, eyes gently closed, totally at peace, a quiet calm radiating from him.
Large bold left-aligned headline text at the top reads: QUIET THE NOISE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You can train the
network that overthinks.
One sit at a time.
At the bottom in bold text: Follow @stillmeditation.app for Day 63"

echo ""
echo "=== Day 62 Complete ==="
