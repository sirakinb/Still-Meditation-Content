#!/bin/bash
# Generate Day 76 slides: "Non-dual awareness: who is meditating?" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day76"

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
The scene: The mascot sits in meditation pose with eyes gently closed, one hand raised toward his own face as if looking inward, soft contemplative expression, warm golden light behind him.
Large bold left-aligned headline text at the top reads: WHO IS
MEDITATING?
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Turn your attention
around.
Look for the one
who is looking."

# Slide 2 — THE QUESTION
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits cross-legged with a thoughtful finger-on-chin pose, eyes wide and curious, a subtle glow radiating from his head suggesting inner inquiry.
Large bold left-aligned headline text at the top reads: THE QUESTION
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Ask yourself:
Who is aware of
these thoughts?
Who is watching?"

# Slide 3 — STEP 1: SETTLE IN
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in a relaxed upright meditation posture, eyes softly closed, hands resting on knees, calm and grounded expression, soft breath visible.
Large bold left-aligned headline text at the top reads: STEP 1: SETTLE IN
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Close your eyes.
Let thoughts arise.
Don't control them.
Just breathe."

# Slide 4 — STEP 2: ASK
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation with one hand gently pressed to his temple, eyes lightly closed, a look of quiet inward turning on his face.
Large bold left-aligned headline text at the top reads: STEP 2: ASK
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Silently ask:
Who is aware right now?
Turn attention
back on itself."

# Slide 5 — STEP 3: LOOK
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot peers inward with eyes wide open and searching, leaning slightly forward with curiosity, open hands in a gesture of looking and finding — and finding nothing solid.
Large bold left-aligned headline text at the top reads: STEP 3: LOOK
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Look for the meditator.
Search carefully.
What do you find?
Nothing fixed."

# Slide 6 — WHAT YOU FIND
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with arms slightly open and palms up in a gesture of release and openness, a serene wide smile, soft light radiating all around him — a sense of vast open space.
Large bold left-aligned headline text at the top reads: WHAT YOU FIND
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Just open awareness.
No fixed self inside.
Sam Harris calls this
the most important insight."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with arms relaxed at his sides, a calm knowing half-smile, soft warm light all around him — radiating quiet confidence and openness.
Large bold left-aligned headline text at the top reads: THE LOOKER
IS LOOKING.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: There is no meditator.
Only meditation.
Try it tonight.
At the bottom in bold text: Follow @stillmeditation for Day 77"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with arms relaxed at his sides, a calm knowing half-smile, soft warm light all around him — radiating quiet confidence and openness.
Large bold left-aligned headline text at the top reads: THE LOOKER
IS LOOKING.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: There is no meditator.
Only meditation.
Try it tonight.
At the bottom in bold text: Follow @stillmeditation.app for Day 77"

echo ""
echo "=== Day 76 Complete ==="
