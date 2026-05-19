#!/bin/bash
# Generate Day 47 slides: "After 6 weeks of meditation, your brain looks different on a scan" — SCIENCE
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day47"

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
The scene: The mascot sits cross-legged in meditation with eyes softly closed, a soft glowing outline of a brain visible just above his head, gentle warm light around him.
Large bold left-aligned headline text at the top reads: 6 WEEKS IN.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Your brain
looks different
on a scan."

# Slide 2 — The claim
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands calmly with one hand on his chin, thoughtful curious expression, soft natural light.
Large bold left-aligned headline text at the top reads: THE SCAN
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: fMRI studies
show real
structural change."

# Slide 3 — Change #1: Prefrontal cortex
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation pose with a focused calm expression, a soft warm glow at his forehead, eyes softly closed.
Large bold left-aligned headline text at the top reads: CHANGE 1
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Prefrontal cortex
activity goes up.
Focus sharpens."

# Slide 4 — Change #2: Default mode network
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in meditation, eyes softly closed, very calm peaceful expression, wisps of thin gray cloud thoughts gently drifting away from his head and dissolving.
Large bold left-aligned headline text at the top reads: CHANGE 2
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Default mode
network quiets.
Mind-wandering drops."

# Slide 5 — Change #3: Attention networks
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation with sharp focused expression, eyes softly closed, soft glowing lines connecting different points around his head suggesting strong neural connections.
Large bold left-aligned headline text at the top reads: CHANGE 3
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Attention networks
connect stronger.
You stay on task."

# Slide 6 — What this means
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall with a calm confident expression, hand on his chest, soft warm light around him, steady relaxed posture.
Large bold left-aligned headline text at the top reads: THE TRUTH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You are literally
remodeling
your brain."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a peaceful half-smile, soft warm light around him, in the bottom half of the image only.
At the top in large bold left-aligned text: KEEP GOING.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Six weeks. Real change.
Line 2: The brain is listening.
At the bottom in bold smaller text: Follow @stillmeditation for Day 48
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a peaceful half-smile, soft warm light around him, in the bottom half of the image only.
At the top in large bold left-aligned text: KEEP GOING.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Six weeks. Real change.
Line 2: The brain is listening.
At the bottom in bold smaller text: Follow @stillmeditation.app for Day 48
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

echo ""
echo "=== Day 47 Complete ==="
