#!/bin/bash
# Generate Day 87 slides: "Build your personal breathwork routine" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day87"

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
The scene: The mascot stands in a relaxed open stance, one hand on his chest and one arm extended outward in invitation, calm confident smile, soft morning light, zen room background.
Large bold left-aligned headline text at the top reads: YOUR BREATHWORK
FITS YOUR LIFE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Not someone else's routine.
Yours. Built for your
schedule and your needs."

# Slide 2 — The Framework
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits in meditation pose, calm and composed, eyes softly closed, a sense of steady daily rhythm around him.
Large bold left-aligned headline text at the top reads: THE FRAMEWORK
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 4 windows.
4 techniques.
One sustainable practice."

# Slide 3 — Morning Energy
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright in early morning light, a bright energised expression, soft golden sunrise light through a window behind him, alert and awake.
Large bold left-aligned headline text at the top reads: MORNING ENERGY
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 2 min diaphragmatic.
Then 3 min box breathing.
Wakes the body. Sharpens focus."

# Slide 4 — Afternoon Reset
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits at a desk mid-afternoon, shoulders dropping into relaxation, eyes gently closed, a sense of midday calm reclaimed.
Large bold left-aligned headline text at the top reads: AFTERNOON RESET
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 2 min coherent breathing.
5 seconds in. 5 seconds out.
Steadies stress before it peaks."

# Slide 5 — Evening Wind-Down
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in a softly lit evening room, eyes closed, body fully relaxed, warm candlelight and a calm winding-down atmosphere.
Large bold left-aligned headline text at the top reads: EVENING WIND-DOWN
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 4-7-8 breathing.
Then a body scan.
Signals the brain: day is done."

# Slide 6 — Weekend Deep Practice
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in a long deep meditation pose on a weekend morning, completely still, a sense of spacious unhurried time, warm soft light.
Large bold left-aligned headline text at the top reads: WEEKEND DEEP PRACTICE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 15 minutes combined.
All techniques. No rush.
This is where depth builds."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and grounded, calm confident smile, both hands relaxed at his sides, warm light around him — a sense of having everything they need.
Large bold left-aligned headline text at the top reads: YOUR BREATH.
YOUR ROUTINE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Design it once.
Practice it daily.
At the bottom in bold text: Follow @stillmeditation for Day 88"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and grounded, calm confident smile, both hands relaxed at his sides, warm light around him — a sense of having everything they need.
Large bold left-aligned headline text at the top reads: YOUR BREATH.
YOUR ROUTINE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Design it once.
Practice it daily.
At the bottom in bold text: Follow @stillmeditation.app for Day 88"

echo ""
echo "=== Day 87 Complete ==="
