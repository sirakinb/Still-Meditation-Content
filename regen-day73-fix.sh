#!/bin/bash
# Regen Day 73 — fix slide 3 (typo) and slide 7 (nested frame artifact)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day73"

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

# Slide 3 fix — typo "No force on cut" → "No force on the out"
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in a relaxed seated position, mouth slightly open on a big inhale, chest fully expanded, one hand resting on knee, calm powerful expression.
Large bold left-aligned headline text at the top reads: STEP 1: BREATHE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text, EXACTLY these lines spelled correctly:
30 deep breaths.
Full inhale through
nose or mouth.
Relaxed exhale —
let it go naturally.
No force on the out.
CRITICAL: The last line MUST read exactly 'No force on the out.' — spell every word correctly."

# Slide 7 fix — remove nested inner frame around mascot
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
IMPORTANT: There must be NO inner box, NO inner frame, NO secondary card, NO picture-in-picture rectangle anywhere in this image. The mascot floats in the same open scene as the text — they share one unified background. DO NOT add any bordered rectangle or inset box around the mascot.
The scene: The mascot sits in a powerful upright meditation pose on a wooden floor in a zen room, both hands on knees, eyes open with a calm intense gaze — like someone who has just completed a Wim Hof round and feels transformed.
Large bold left-aligned headline text at the top reads: BREATHWORK'S
FINAL BOSS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Three rounds.
Done in 15 minutes.
Your body will feel
completely different.
At the bottom in bold text, EXACTLY: Follow @stillmeditation for Day 74
The username MUST be spelled exactly: @stillmeditation (one word, do NOT duplicate the word still)"

echo ""
echo "=== Day 73 Regen Fix Complete ==="
