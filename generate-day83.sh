#!/bin/bash
# Generate Day 83 slides: "I should be further along by now" — MYTH-BUSTING
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day83"

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
The scene: The mascot sits cross-legged in meditation pose, calm and settled, with a gentle confident smile — completely at ease exactly where he is.
Large bold left-aligned headline text at the top reads: I SHOULD BE FURTHER ALONG BY NOW.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Myth.
There is no 'further along.'
There's only here."

# Slide 2 — The Myth
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands with arms crossed, head tilted, a slightly skeptical but thoughtful expression — like someone questioning a familiar assumption.
Large bold left-aligned headline text at the top reads: THE MYTH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Your mind compares.
It measures. It creates
stories about progress."

# Slide 3 — Every Session Counts
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot holds both hands open, palms up, balanced and present — offering something freely.
Large bold left-aligned headline text at the top reads: EVERY SESSION COUNTS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: A restless session at
Day 83 teaches as much
as a calm one at Day 3."

# Slide 4 — Progress Isn't Linear
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands relaxed with a knowing half-smile, one hand loosely at his side, steady and unrattled.
Large bold left-aligned headline text at the top reads: PROGRESS ISN'T LINEAR
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Some days the mind stills.
Other days it races.
Both are real practice."

# Slide 5 — Comparison Is The Trap
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with one hand raised gently, pointing upward, a calm alert expression — catching a thought in the act.
Large bold left-aligned headline text at the top reads: COMPARISON IS THE TRAP
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Comparing to a past self
is just more thinking.
Noticing that? Meditation."

# Slide 6 — The Reframe
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation, eyes softly closed, completely still and at peace — no striving, just presence.
Large bold left-aligned headline text at the top reads: THE REFRAME
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Presence is the only
metric that matters.
You already have it."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall, arms relaxed, eyes open with a warm steady gaze — grounded and exactly where he needs to be.
Large bold left-aligned headline text at the top reads: JUST THIS MOMENT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Not further along.
Not behind.
Right here is the practice.
At the bottom in bold text: Follow @stillmeditation for Day 84"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall, arms relaxed, eyes open with a warm steady gaze — grounded and exactly where he needs to be.
Large bold left-aligned headline text at the top reads: JUST THIS MOMENT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Not further along.
Not behind.
Right here is the practice.
At the bottom in bold text: Follow @stillmeditation.app for Day 84"

echo ""
echo "=== Day 83 Complete ==="
