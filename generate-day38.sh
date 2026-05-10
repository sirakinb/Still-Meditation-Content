#!/bin/bash
# Generate Day 38 slides: "The breathing technique that sounds like the ocean" (TUTORIAL — Ujjayi)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day38"

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

  # Surface API errors loudly instead of silently writing 0-byte PNGs
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

  # Sanity-check file size (real PNGs are >100KB; 0-byte means silent failure)
  size=$(stat -f%z "$filename" 2>/dev/null || stat -c%s "$filename")
  if [ "$size" -lt 10000 ]; then
    echo "✗ Slide ${slide_num} FAILED: output file is only ${size} bytes" >&2
    exit 1
  fi
  echo "✓ Slide ${slide_num} saved (${size} bytes)"
}

# Slide 1 — Hook
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in calm meditation, eyes softly closed, peaceful expression, soft blue ocean-like waves of light gently flowing around him.
Large bold left-aligned headline text at the top reads: BREATHE LIKE THE OCEAN.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: One technique.
Calm in 60 seconds.
No app needed."

# Slide 2 — What it is
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands upright, gentle hand near his throat, calm focused expression.
Large bold left-aligned headline text at the top reads: MEET UJJAYI
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Victorious breath.
Used for 3000 years.
Sounds like waves."

# Slide 3 — The throat
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot demonstrates softly fogging an imaginary mirror with his open mouth, gentle steam puff visible.
Large bold left-aligned headline text at the top reads: STEP 1
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Open your mouth.
Fog a mirror.
Feel the throat narrow."

# Slide 4 — Close mouth
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits calmly, mouth gently closed, peaceful focused expression, soft glow around his nose suggesting airflow.
Large bold left-aligned headline text at the top reads: STEP 2
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Close your mouth.
Keep that throat shape.
Breathe through the nose."

# Slide 5 — The count
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged, deeply focused, soft warm light, hand resting on knee.
Large bold left-aligned headline text at the top reads: STEP 3
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Inhale 4 counts.
Exhale 6 counts.
Soft ocean sound."

# Slide 6 — Why it works
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall and grounded, calm confident expression, soft warm light around him.
Large bold left-aligned headline text at the top reads: WHY IT WORKS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Slows the breath.
Vagus nerve fires.
Mind quiets fast."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in calm meditation, eyes softly closed, peaceful expression, gentle ocean-blue waves of light flowing around him.
Large bold left-aligned headline text at the top reads: TRY 5 ROUNDS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 60 seconds.
Feel the shift.
At the bottom in bold text: Follow @stillmeditation for Day 39"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in calm meditation, eyes softly closed, peaceful expression, gentle ocean-blue waves of light flowing around him.
Large bold left-aligned headline text at the top reads: TRY 5 ROUNDS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 60 seconds.
Feel the shift.
At the bottom in bold text: Follow @stillmeditation.app for Day 39"

echo ""
echo "=== Day 38 Complete ==="
