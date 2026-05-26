#!/bin/bash
# Generate Day 53 slides: "Breath retention: holding space between breaths" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day53"

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
The scene: The mascot sits cross-legged in meditation, eyes softly closed, perfectly still, one hand resting on his knee, soft warm light, deeply peaceful expression.
Large bold left-aligned headline text at the top reads: THE PAUSE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The space between
breaths is where
the magic lives."

# Slide 2 — What it is
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with arms relaxed and a calm focused expression, soft natural light.
Large bold left-aligned headline text at the top reads: KUMBHAKA
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Sanskrit for
breath retention.
The yogi pause."

# Slide 3 — Step 1
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright cross-legged with a calm focused look, taking a slow inhale, soft natural light.
Large bold left-aligned headline text at the top reads: STEP 1: INHALE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Slow comfortable
breath in through
the nose."

# Slide 4 — Step 2
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits very still in meditation, eyes softly closed, mouth gently closed, deeply quiet posture, soft warm light.
Large bold left-aligned headline text at the top reads: STEP 2: HOLD
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Pause at the top.
Four full seconds.
Lungs softly full."

# Slide 5 — Step 3
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged with a soft relaxed exhale, calm peaceful expression, slight smile.
Large bold left-aligned headline text at the top reads: STEP 3: EXHALE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Slow release out
through the nose.
Empty completely."

# Slide 6 — Step 4
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits perfectly still, eyes softly closed, completely empty and quiet, a small calm smile, soft natural light.
Large bold left-aligned headline text at the top reads: STEP 4: HOLD
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Pause at the bottom.
Two to four seconds.
Then inhale again."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 40% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a soft confident half-smile, peaceful posture, warm glow around him.
At the top in large bold left-aligned text: TRY IT TONIGHT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines, EXACTLY as written, with NO line numbers or labels:
Five minutes.
Five rounds.
At the bottom in bold smaller text: Follow @stillmeditation for Day 54
Do NOT write the words 'Line 1' or 'Line 2' anywhere — those are just formatting instructions, not part of the visible text. Spell every word correctly."

# Slide 7 — IG variant
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 40% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a soft confident half-smile, peaceful posture, warm glow around him.
At the top in large bold left-aligned text: TRY IT TONIGHT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines, EXACTLY as written, with NO line numbers or labels:
Five minutes.
Five rounds.
At the bottom in bold smaller text: Follow @stillmeditation.app for Day 54
Do NOT write the words 'Line 1' or 'Line 2' anywhere — those are just formatting instructions, not part of the visible text. Spell every word correctly."

echo ""
echo "=== Day 53 Complete ==="
