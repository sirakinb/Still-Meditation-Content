#!/bin/bash
# Generate Day 46 slides: "Visualization meditation: building pictures in your mind" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day46"

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
The scene: The mascot sits cross-legged in meditation with eyes softly closed, a small glowing warm golden orb of light floating just above the top of his head, soft rays radiating downward.
Large bold left-aligned headline text at the top reads: GOLDEN LIGHT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Close your eyes
and imagine a light
above your head."

# Slide 2 — What this is
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands calmly, one hand resting on his chest, gentle thoughtful expression, soft natural light.
Large bold left-aligned headline text at the top reads: WHAT IT IS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Visualization uses
your mind's natural
imaging ability."

# Slide 3 — Step 1: PICTURE THE LIGHT
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in meditation pose, eyes softly closed, peaceful expression, with a small warm golden glowing orb of light hovering directly above the top of his head, casting a soft warm glow downward.
Large bold left-aligned headline text at the top reads: STEP 1: PICTURE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Warm golden light.
Hovering just above
the top of your head."

# Slide 4 — Step 2: INHALE — LIGHT FLOWS DOWN
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in meditation, eyes softly closed, calm relaxed expression, with soft warm golden light streaming gently downward through his body from the top of his head — visible as a soft glowing column of warm yellow-gold light flowing through his torso.
Large bold left-aligned headline text at the top reads: STEP 2: INHALE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: With each breath in,
the light flows down
through your body."

# Slide 5 — Step 3: EXHALE — DARK SMOKE LEAVES
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in meditation with a soft relaxed exhale, eyes softly closed, with wisps of thin dark gray smoke drifting gently outward and away from his shoulders and chest, dissolving into the air.
Large bold left-aligned headline text at the top reads: STEP 3: EXHALE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Tension leaves
as dark smoke
on every exhale."

# Slide 6 — Why it works
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation pose with a calm focused expression, one hand resting on his knee, soft warm light, peaceful steady posture.
Large bold left-aligned headline text at the top reads: WHY IT WORKS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The mind that wanders
loves a picture.
Give it one on purpose."

# Slide 7 — CTA (TikTok variant)
# Lesson from Day 45: enforce mascot in BOTTOM HALF so text never overlaps.
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a peaceful half-smile, a soft warm golden glow around him, in the bottom half of the image only.
At the top in large bold left-aligned text: TRY IT TONIGHT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Five minutes.
Line 2: Eyes closed. Light on.
At the bottom in bold smaller text: Follow @stillmeditation for Day 47
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a peaceful half-smile, a soft warm golden glow around him, in the bottom half of the image only.
At the top in large bold left-aligned text: TRY IT TONIGHT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Five minutes.
Line 2: Eyes closed. Light on.
At the bottom in bold smaller text: Follow @stillmeditation.app for Day 47
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

echo ""
echo "=== Day 46 Complete ==="
