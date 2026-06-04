#!/bin/bash
# Generate Day 64 slides: "Bhastrika: the bellows breath" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day64"

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
The scene: The mascot sits cross-legged in a dynamic energized pose, chest expanded, nostrils flared with visible breath lines suggesting powerful inhalation and exhalation, eyes open and alert with focus.
Large bold left-aligned headline text at the top reads: KAPALABHATI'S
INTENSE COUSIN
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: This breathing technique
can energize you in
3 minutes flat.
But you need to earn it first."

# Slide 2 — The Technique
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands upright with both hands on his belly, demonstrating diaphragm engagement, confident teaching expression.
Large bold left-aligned ALL-CAPS headline text at the top reads: THE TECHNIQUE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Bhastrika = bellows breath.
Equal force on BOTH
inhale AND exhale.
Full diaphragm — both ways."

# Slide 3 — The Inhale
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot inhales deeply with chest and belly fully expanded, one hand on belly showing the expansion, energized wide-awake expression.
Large bold left-aligned ALL-CAPS headline text at the top reads: THE INHALE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Breathe IN forcefully
through the nose.
Full belly expansion.
Not a sip — a surge."

# Slide 4 — The Exhale
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot exhales powerfully with belly contracted, visible breath lines showing forceful exhalation outward through the nose, strong focused expression.
Large bold left-aligned ALL-CAPS headline text at the top reads: THE EXHALE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Breathe OUT with equal force.
Push every bit of air out.
Same power as the inhale.
That is what makes it different."

# Slide 5 — The Round
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation pose with a timer or counting gesture, calm focused expression showing control and rhythm.
Large bold left-aligned ALL-CAPS headline text at the top reads: THE ROUND
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 20 rapid breaths = 1 round.
Complete 3 rounds total.
Rest 30 to 60 seconds between.
Let your system settle."

# Slide 6 — The Warning
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot holds up one hand in a calm stop gesture with a serious but caring expression, protective posture conveying an important safety message.
Large bold left-aligned ALL-CAPS headline text at the top reads: IMPORTANT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Only attempt Bhastrika
after mastering Kapalabhati.
Feel dizzy? Stop immediately.
This is a graduation, not a shortcut."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with arms slightly raised, chest open, energized and glowing with a calm powerful presence, triumphant but grounded expression.
Large bold left-aligned headline text at the top reads: BELLOWS BREATH.
FULL POWER.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: When done right:
your body hums.
your mind clears.
your energy surges.
At the bottom in bold text: Follow @stillmeditation for Day 65"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with arms slightly raised, chest open, energized and glowing with a calm powerful presence, triumphant but grounded expression.
Large bold left-aligned headline text at the top reads: BELLOWS BREATH.
FULL POWER.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: When done right:
your body hums.
your mind clears.
your energy surges.
At the bottom in bold text: Follow @stillmeditation.app for Day 65"

echo ""
echo "=== Day 64 Complete ==="
