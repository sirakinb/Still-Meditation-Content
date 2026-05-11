#!/bin/bash
# Generate Day 41 slides: "How to meditate when your emotions are intense" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day41"

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
The scene: The mascot sits calmly in a cross-legged meditation pose, one hand on his chest, eyes softly closed in a peaceful steady expression, soft warm light.
Large bold left-aligned headline text at the top reads: INTENSE EMOTION?
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Don't meditate
your feelings away.
Meditate INTO them."

# Slide 2 — The common mistake
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot has a gentle understanding expression, one open hand reaching forward in invitation.
Large bold left-aligned headline text at the top reads: THE MISTAKE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Most try to push
feelings away.
That makes them louder."

# Slide 3 — Step 1: NAME IT
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright with calm grounded posture, one finger gently raised as if naming something out loud, soft focused gaze.
Large bold left-aligned headline text at the top reads: STEP 1: NAME IT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Anger. Sadness.
Fear. Say it silently.
Naming calms the brain."

# Slide 4 — Step 2: LOCATE IT
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with one hand on his chest and the other on his stomach, eyes softly closed, attentive listening expression.
Large bold left-aligned headline text at the top reads: STEP 2: LOCATE IT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Tight chest.
Heavy stomach.
Find where it lives."

# Slide 5 — Step 3: BREATHE INTO IT
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation pose with a soft warm glow around his chest, deep relaxed breath, peaceful expression.
Large bold left-aligned headline text at the top reads: STEP 3: BREATHE IN
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Send slow breath
to that exact spot.
Let it soften."

# Slide 6 — Step 4: OBSERVE, DON'T CHANGE
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits perfectly still with relaxed shoulders, soft steady gaze forward, calm unshaken posture.
Large bold left-aligned headline text at the top reads: STEP 4: OBSERVE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Don't fix it.
Just watch.
Emotions are waves."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident with a calm half-smile, both hands relaxed at his sides, soft warm light around him.
Large bold left-aligned headline text at the top reads: SIT WITH IT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Every wave crests.
Every wave falls.
You're still here.
At the bottom in bold text: Follow @stillmeditation for Day 42"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident with a calm half-smile, both hands relaxed at his sides, soft warm light around him.
Large bold left-aligned headline text at the top reads: SIT WITH IT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Every wave crests.
Every wave falls.
You're still here.
At the bottom in bold text: Follow @stillmeditation.app for Day 42"

echo ""
echo "=== Day 41 Complete ==="
