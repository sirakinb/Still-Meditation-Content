#!/bin/bash
# Generate Day 78 slides: "The dose-response curve: how much meditation is enough" (SCIENCE)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day78"

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
The scene: The mascot stands confident and grounded, arms relaxed at sides, calm knowing expression, soft warm light around him suggesting wisdom and completion.
Large bold left-aligned headline text at the top reads: AFTER 90 DAYS, HERE'S THE MINIMUM TO KEEP YOUR GAINS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You don't need an hour.
You need consistency.
Science says 10 minutes is enough."

# Slide 2 — What is the dose-response curve
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands looking thoughtful, calm engaged expression, soft neutral light.
Large bold left-aligned headline text at the top reads: THE DOSE-RESPONSE CURVE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: More practice.
More benefit.
But only up to a point."

# Slide 3 — The sweet spot
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in a calm meditation pose, eyes softly closed, peaceful expression, soft warm glow around him.
Large bold left-aligned headline text at the top reads: THE SWEET SPOT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 10 to 20 minutes daily.
Maintains every benefit
you have built."

# Slide 4 — Diminishing returns
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with a calm, measured expression, one hand raised open as if presenting a balanced truth, soft natural light.
Large bold left-aligned headline text at the top reads: PAST 45 MINUTES
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Returns flatten out.
More time. Same result.
The curve levels off."

# Slide 5 — Consistency beats duration
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands strong and grounded with a calm steady expression, both feet planted, soft warm light, posture of quiet confidence.
Large bold left-aligned headline text at the top reads: CONSISTENCY WINS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Daily 10 minutes.
Beats sporadic 45-minute
sessions every time."

# Slide 6 — What this means for you
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright in a meditation cushion, eyes softly closed, calm purposeful expression, soft natural light, peaceful and settled.
Large bold left-aligned headline text at the top reads: YOUR MINIMUM DOSE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 10 to 15 minutes.
Every day.
That is a lifetime practice."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident with a calm half-smile, one hand resting on his chest, soft warm glow around him, grounded and complete.
Large bold left-aligned headline text at the top reads: YOUR 10 MINUTES IS ENOUGH.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Science confirms it.
Keep showing up.
At the bottom in bold text: Follow @stillmeditation for Day 79"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident with a calm half-smile, one hand resting on his chest, soft warm glow around him, grounded and complete.
Large bold left-aligned headline text at the top reads: YOUR 10 MINUTES IS ENOUGH.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Science confirms it.
Keep showing up.
At the bottom in bold text: Follow @stillmeditation.app for Day 79"

echo ""
echo "=== Day 78 Complete ==="
