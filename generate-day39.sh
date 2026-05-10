#!/bin/bash
# Generate Day 39 slides: "4 breathing patterns for 4 different situations" (QUICK TIP)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day39"

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
The scene: The mascot stands confidently with both arms relaxed at his sides, calm focused expression, looking ahead. Around him, four soft glowing breath-icons float at chest height — small wave, square, lightning bolt, balanced circle — but stay in the lower half away from the title text.
Large bold left-aligned headline text at the top reads: PICK THE RIGHT BREATH.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 4 patterns.
4 different jobs.
1 minute each."

# Slide 2 — Intro
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands upright, calm confident expression, one hand resting on his chest near his heart.
Large bold left-aligned headline text at the top reads: YOUR BREATH IS A TOOL
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Most people use one button.
You have four.
Match the pattern to the moment."

# Slide 3 — Need calm: 4-7-8
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot lies relaxed against soft pillows or sits with eyes gently closed, deeply peaceful expression, soft moonlight or evening glow.
Large bold left-aligned headline text at the top reads: NEED CALM?
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 4-7-8 breathing.
Inhale 4. Hold 7. Exhale 8.
Best before bed."

# Slide 4 — Need focus: Box breathing
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands sharp and alert, shoulders back, focused steady gaze, calm warrior energy.
Large bold left-aligned headline text at the top reads: NEED FOCUS?
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Box breathing.
4 in. 4 hold. 4 out. 4 hold.
Used by Navy SEALs."

# Slide 5 — Need energy: Quick inhales
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands energized, light coming up through his body, awake confident expression, slight forward lean.
Large bold left-aligned headline text at the top reads: NEED ENERGY?
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 3 quick inhales.
1 long exhale.
Repeat 10 times."

# Slide 6 — Need balance: Coherent breathing
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged, perfectly centered, peaceful balanced expression, soft even glow around him.
Large bold left-aligned headline text at the top reads: NEED BALANCE?
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Coherent breathing.
Inhale 5. Exhale 5.
Hold for 5 minutes."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, soft warm light around him.
Large bold left-aligned headline text at the top reads: PICK ONE. USE IT TODAY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Calm. Focus.
Energy. Balance.
Save this post.
At the bottom in bold text: Follow @stillmeditation for Day 40"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, soft warm light around him.
Large bold left-aligned headline text at the top reads: PICK ONE. USE IT TODAY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Calm. Focus.
Energy. Balance.
Save this post.
At the bottom in bold text: Follow @stillmeditation.app for Day 40"

echo ""
echo "=== Day 39 Complete ==="
