#!/bin/bash
# Regen Day 70 slides 3, 5, 6 — fix "ALL-CAPS" text leaking into header and garbled slide 6 body
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day70"

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

# Slide 3 — Emotions (fixed: header must be exactly the word EMOTIONS, nothing else before it)
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot holds one hand to his chest with a calm, observant expression — like someone noticing a feeling without being swept away by it, a small knowing nod.
EXACTLY these lines spelled correctly, nothing added before them:
Line 1 (large bold header at top): EMOTIONS
LEAVE A CLEAR GAP between line 1 and the lines below.
Line 2 (medium bold body): Can you name it
Line 3: in real time?
Line 4: Before it owns you?
Do NOT add any words before EMOTIONS. The header is the single word: EMOTIONS"

# Slide 5 — Loving-Kindness (fixed: header must be exactly LOVING-KINDNESS, nothing else before it)
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits cross-legged with hands open in his lap, a soft compassionate expression on his face, warm gentle light, the feeling of someone sending quiet warmth to someone difficult.
EXACTLY these lines spelled correctly, nothing added before them:
Line 1 (large bold header at top): LOVING-KINDNESS
LEAVE A CLEAR GAP between line 1 and the lines below.
Line 2 (medium bold body): A difficult person.
Line 3: Can you hold them
Line 4: with warmth?
Do NOT add any words before LOVING-KINDNESS. The header is exactly: LOVING-KINDNESS"

# Slide 6 — Ready (fixed: body text is specific and explicit, no hallucination)
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands tall with a quiet confident expression, both hands slightly raised palms-up, a forward-facing stance — the look of someone ready for what comes next.
EXACTLY these lines spelled correctly, nothing added or changed:
Line 1 (large bold header at top): READY
LEAVE A CLEAR GAP between line 1 and the lines below.
Line 2 (medium bold body): If most answers
Line 3: are yes — you're set
Line 4: for the final phase.
The body text must be EXACTLY those three lines. Do NOT add any other text. Do NOT write anything about spelling or instructions on the card."

echo ""
echo "=== Day 70 Regen Pass 1 Complete ==="
