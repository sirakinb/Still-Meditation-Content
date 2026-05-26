#!/bin/bash
# Generate Day 54 slides: "How slow breathing rewires your nervous system" — SCIENCE
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day54"

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
  if [ -n "$err" ]; then echo "✗ Slide ${slide_num} FAILED: $err" >&2; exit 1; fi
  data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data')
  if [ -z "$data" ] || [ "$data" = "null" ]; then
    echo "✗ Slide ${slide_num} FAILED: no image data" >&2
    echo "$response" | head -c 600 >&2; exit 1
  fi
  echo "$data" | base64 -d > "$filename"
  size=$(stat -f%z "$filename" 2>/dev/null || stat -c%s "$filename")
  if [ "$size" -lt 10000 ]; then echo "✗ Slide ${slide_num} FAILED: ${size} bytes" >&2; exit 1; fi
  echo "✓ Slide ${slide_num} saved (${size} bytes)"
}

# Slide 1 — Hook
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands with a calm focused expression, one hand resting on his chest, soft natural light, peaceful confident posture.
Large bold left-aligned headline text at the top reads: SIX BREATHS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Per minute changes
your entire
physiology."

# Slide 2 — What it is
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands calmly with a thoughtful expression, soft natural light.
Large bold left-aligned headline text at the top reads: THE NUMBER
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Five seconds in.
Five seconds out.
That is the math."

# Slide 3 — What happens
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation pose, hand gently over his heart, eyes softly closed, calm focused expression.
Large bold left-aligned headline text at the top reads: THE SYNC
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Your heart rhythm
locks onto your
breathing rhythm."

# Slide 4 — Resonance
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with both hands on his heart and belly, peaceful focused expression, soft warm glow.
Large bold left-aligned headline text at the top reads: RESONANCE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: This sync maxes
your heart rate
variability."

# Slide 5 — Vagus nerve
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in meditation, calm relaxed expression, hand resting on his throat, eyes softly closed.
Large bold left-aligned headline text at the top reads: THE SHIFT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Sympathetic mode
quiets down.
Calm mode wakes up."

# Slide 6 — Outcome
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall and confident with a soft calm smile, peaceful posture, soft warm glow.
Large bold left-aligned headline text at the top reads: THE PROOF
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Lower blood pressure.
Sharper focus.
Deeper sleep."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 40% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a confident half-smile, peaceful posture, warm glow around him.
At the top in large bold left-aligned text: TRY IT NOW.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines, EXACTLY as written:
Five in. Five out.
Five minutes.
At the bottom in bold smaller text: Follow @stillmeditation for Day 55
Do NOT write the words 'Line 1' or 'Line 2' or any labels — those are just formatting hints. Spell every word correctly."

# Slide 7 — IG variant
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 40% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a confident half-smile, peaceful posture, warm glow around him.
At the top in large bold left-aligned text: TRY IT NOW.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines, EXACTLY as written:
Five in. Five out.
Five minutes.
At the bottom in bold smaller text: Follow @stillmeditation.app for Day 55
Do NOT write the words 'Line 1' or 'Line 2' or any labels — those are just formatting hints. Spell every word correctly."

echo ""
echo "=== Day 54 Complete ==="
