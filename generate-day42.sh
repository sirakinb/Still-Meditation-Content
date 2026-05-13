#!/bin/bash
# Generate Day 42 slides: "The 7-day loving-kindness challenge" — CHALLENGE
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day42"

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
The scene: The mascot sits in a cross-legged meditation pose, both hands resting on his knees palms up, eyes softly closed in a warm peaceful expression, a soft glow around his chest.
Large bold left-aligned headline text at the top reads: 7-DAY CHALLENGE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Expand who you
send kindness to.
One person a day."

# Slide 2 — The phrase
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits upright with one open hand resting over his heart, eyes softly closed, a calm caring expression.
Large bold left-aligned headline text at the top reads: THE PHRASE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: May you be happy.
May you be safe.
May you be free."

# Slide 3 — Days 1 and 2
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in calm meditation with one hand on his own chest, soft warm light around him, gentle self-compassionate expression.
Large bold left-aligned headline text at the top reads: DAYS 1 AND 2
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Day 1: yourself.
Day 2: someone
you deeply love."

# Slide 4 — Days 3 and 4
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with a calm grounded posture, one hand gently extended outward in an offering gesture, warm steady expression.
Large bold left-aligned headline text at the top reads: DAYS 3 AND 4
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Day 3: a friend.
Day 4: a coworker
you barely know."

# Slide 5 — Days 5 and 6
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with steady open posture, both hands resting on his knees, eyes softly closed, a strong calm compassionate expression.
Large bold left-aligned headline text at the top reads: DAYS 5 AND 6
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Day 5: a stranger.
Day 6: someone
you find difficult."

# Slide 6 — Day 7
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in serene meditation with both arms gently open wide, a soft warm glow expanding around him outward, peaceful expansive expression.
Large bold left-aligned headline text at the top reads: DAY 7
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: All beings
everywhere.
The full circle."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident with a warm half-smile, both hands resting gently over his heart, soft warm radiant light around him.
Large bold left-aligned headline text at the top reads: START TONIGHT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: One person a day.
Watch your heart
expand by Day 7.
At the bottom in bold text: Follow @stillmeditation for Day 43"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident with a warm half-smile, both hands resting gently over his heart, soft warm radiant light around him.
Large bold left-aligned headline text at the top reads: START TONIGHT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: One person a day.
Watch your heart
expand by Day 7.
At the bottom in bold text: Follow @stillmeditation.app for Day 43"

echo ""
echo "=== Day 42 Complete ==="
