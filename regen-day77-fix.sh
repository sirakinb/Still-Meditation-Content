#!/bin/bash
# Regen broken slides for Day 77: slides 2, 3, 5
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day77"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm zen meditation room with wooden floors, soft natural light, green plants — UNLESS the scene calls for another setting. DO NOT include any text branding or logo anywhere. DO NOT draw any internal frames, borders, mini-cards, or picture-in-picture elements — the mascot is part of the same single scene as the text. Light warm background with rounded corners on the OUTER card only. Text should be bold, large, left-aligned, and highly readable for mobile viewing. Spell every word correctly. 4:5 portrait orientation. Only ONE instance of the mascot per image."

generate_slide() {
  local slide_num=$1
  local prompt=$2
  local filename="${OUTPUT_DIR}/slide${slide_num}.png"

  echo "Regenerating Slide ${slide_num}..."
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

# Slide 2 — WHY BUILD YOUR OWN (FIX: leaked style text + nested mini-card)
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, blending seamlessly into the same scene — NO separate box, NO border, NO mini-card around the mascot. The mascot and text share one unified card.
The scene: The mascot sits in a proud, self-assured meditation posture, eyes softly closed, a quiet confident expression.
IMPORTANT: The ONLY text that must appear on this card is EXACTLY these lines spelled correctly:
Line 1 (large bold ALL-CAPS header): WHY BUILD YOUR OWN
[blank gap]
Line 2 (medium bold): The best practice
Line 3 (medium bold): is the one you do.
Line 4 (medium bold): You know what works.
Line 5 (medium bold): Time to own it.
DO NOT add any other words, sentences, or phrases beyond these five lines. DO NOT render any style instructions as card text."

# Slide 3 — STEP 1 (FIX: spelling error 'shifing' → 'shifting')
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits upright, eyes closed, with a slow steady breath visible as a soft glow around his chest — a breathwork warm-up pose, calm and focused.
IMPORTANT: The ONLY text that must appear on this card is EXACTLY these lines spelled correctly:
Line 1 (large bold ALL-CAPS header): STEP 1
[blank gap]
Line 2 (medium bold): Breathwork warm-up.
Line 3 (medium bold): 3 minutes.
Line 4 (medium bold): Box breath, 4-7-8,
Line 5 (medium bold): or Wim Hof lite.
Line 6 (medium bold): Signal: we're shifting gears.
The word MUST be spelled: s-h-i-f-t-i-n-g (shifting). NOT 'shifing'. Spell it correctly: shifting."

# Slide 5 — STEP 4 (FIX: spelling error 'techecnique' → 'technique', mascot overlap)
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING overlapping into the left text zone. Keep the mascot entirely within the right side.
The scene: The mascot sits with both hands resting on knees, completely open and relaxed, eyes gently closed — no technique, no effort, just pure open sitting awareness.
IMPORTANT: The ONLY text that must appear on this card is EXACTLY these lines spelled correctly:
Line 1 (large bold ALL-CAPS header): STEP 4
[blank gap]
Line 2 (medium bold): Choiceless awareness.
Line 3 (medium bold): 5 minutes.
Line 4 (medium bold): No anchor. No technique.
Line 5 (medium bold): Sit with whatever arises.
Line 6 (medium bold): No training wheels.
The word MUST be spelled: t-e-c-h-n-i-q-u-e (technique). NOT 'techecnique' or any other misspelling. Spell it correctly: technique."

echo ""
echo "=== Day 77 Regen Complete ==="
