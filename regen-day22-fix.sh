#!/bin/bash
# Regenerate Day 22 slide 7 (TikTok + Instagram variants) with shorter text
# Original had: text duplication on TT version, misspelled @stillmeditationion.app on IG version
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day22"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: warm zen meditation room with wooden floors, soft natural light, green plants. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

generate_slide() {
  local slide_num=$1
  local prompt=$2
  local filename="${OUTPUT_DIR}/slide${slide_num}.png"

  echo "Generating Slide ${slide_num}..."
  response=$(curl -s -X POST "${ENDPOINT}" \
    -H "x-goog-api-key: ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{\"contents\":[{\"parts\":[{\"text\": $(echo "$prompt" | jq -Rs .)}]}],\"generationConfig\":{\"responseModalities\":[\"TEXT\",\"IMAGE\"]}}")
  echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' | base64 -d > "$filename"
  echo "✓ Slide ${slide_num} saved"
}

# Slide 7 TikTok — short, simple lines that won't get garbled
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands strong and confident, one fist raised in determination, looking forward with focus. A glowing horizontal progress bar behind him is roughly 1/3 filled.
Render EXACTLY this text — do not paraphrase, duplicate, or split words across lines:
Top headline (large bold left-aligned):
DON'T QUIT BEFORE THE BREAKTHROUGH.
LEAVE A CLEAR GAP between headline and body.
Body (medium bold, three short separate lines, render each line on its own row):
You're at Day 22 of 66.
The breakthrough is days away.
Keep going.
At the bottom in bold text:
Follow @stillmeditation for Day 23"

# Slide 7 Instagram — same structure, IG handle (no extra letters!)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands strong and confident, one fist raised in determination, looking forward with focus. A glowing horizontal progress bar behind him is roughly 1/3 filled.
Render EXACTLY this text — do not paraphrase, duplicate, or split words across lines:
Top headline (large bold left-aligned):
DON'T QUIT BEFORE THE BREAKTHROUGH.
LEAVE A CLEAR GAP between headline and body.
Body (medium bold, three short separate lines, render each line on its own row):
You're at Day 22 of 66.
The breakthrough is days away.
Keep going.
At the bottom in bold text, render this handle EXACTLY with no extra letters:
Follow @stillmeditation.app for Day 23"

echo ""
echo "=== Day 22 slide 7 fixes complete ==="
