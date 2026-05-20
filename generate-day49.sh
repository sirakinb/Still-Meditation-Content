#!/bin/bash
# Generate Day 49 slides: "How to transition from breathwork into meditation" — QUICK TIP
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day49"

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
    exit 1
  fi
  data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data')
  if [ -z "$data" ] || [ "$data" = "null" ]; then
    echo "✗ Slide ${slide_num} FAILED: no image data" >&2
    echo "$response" | head -c 600 >&2
    exit 1
  fi
  echo "$data" | base64 -d > "$filename"
  size=$(stat -f%z "$filename" 2>/dev/null || stat -c%s "$filename")
  if [ "$size" -lt 10000 ]; then
    echo "✗ Slide ${slide_num} FAILED: file only ${size} bytes" >&2
    exit 1
  fi
  echo "✓ Slide ${slide_num} saved (${size} bytes)"
}

# Slide 1 — Hook
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in meditation pose, eyes calm and softly open, a small confident smile, soft warm natural light.
Large bold left-aligned headline text at the top reads: THE SECRET TO DEEPER MEDITATION?
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Start with
breathwork."

# Slide 2 — The problem
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged, eyes closed, a slightly frustrated expression with a small thought cloud showing tangled scribbles above his head, soft warm light.
Large bold left-aligned headline text at the top reads: THE PROBLEM
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You sit down.
Your mind races.
You give up."

# Slide 3 — Step 1: 3 min breathwork
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright cross-legged, hands on his knees, a focused calm expression, breathing actively.
Large bold left-aligned headline text at the top reads: STEP 1: BREATHE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Three minutes
of box breathing.
Clear the clutter."

# Slide 4 — Step 2: 1 min transition
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in meditation, a calm peaceful expression, hands resting on knees, eyes softly open.
Large bold left-aligned headline text at the top reads: STEP 2: LET GO
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: One minute.
Watch the breath.
Do not control it."

# Slide 5 — Step 3: meditate
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in deep meditation, eyes gently closed, a serene smile, a soft warm glow around him.
Large bold left-aligned headline text at the top reads: STEP 3: SETTLE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Now meditate.
The mind is quiet.
You drop in fast."

# Slide 6 — The science
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall with arms relaxed, a confident knowing smile, soft warm glow.
Large bold left-aligned headline text at the top reads: THE SCIENCE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Stanford found
breathwork beats
meditation alone."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a small reassuring smile, soft warm glow around him, in the bottom half of the image only.
At the top in large bold left-aligned text: TRY IT TONIGHT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Breathwork first.
Line 2: Then meditate.
At the bottom in bold smaller text: Follow @stillmeditation for Day 50
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

# Slide 7 — IG variant
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 50% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF only, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a small reassuring smile, soft warm glow around him, in the bottom half of the image only.
At the top in large bold left-aligned text: TRY IT TONIGHT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines:
Line 1: Breathwork first.
Line 2: Then meditate.
At the bottom in bold smaller text: Follow @stillmeditation.app for Day 50
The headline and body text must be in the empty top half of the image, fully readable, never touching the mascot."

echo ""
echo "=== Day 49 Complete ==="
