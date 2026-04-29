#!/bin/bash
# Regen slides 2, 5, 6 — mascot was naked; need clothing.
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day28"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). The mascot ALWAYS wears a grey athletic tank top and grey athletic shorts — never naked, never bare-chested only. Clean vector-like illustration with bold outlines. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm zen meditation room with wooden floors, soft natural light, green plants. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

generate_slide() {
  local slide_num=$1
  local prompt=$2
  local filename="${OUTPUT_DIR}/slide${slide_num}.png"

  echo "Regenerating Slide ${slide_num}..."
  response=$(curl -s -X POST "${ENDPOINT}" \
    -H "x-goog-api-key: ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{\"contents\":[{\"parts\":[{\"text\": $(echo "$prompt" | jq -Rs .)}]}],\"generationConfig\":{\"responseModalities\":[\"TEXT\",\"IMAGE\"]}}")
  echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' | base64 -d > "$filename"
  echo "✓ Slide ${slide_num} saved"
}

# Slide 2 — Title card
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands wearing a grey athletic tank top and grey athletic shorts, holding a small blueprint or design plan in one hand, calm smile, confident posture.
Large bold left-aligned headline text at the top reads: THE SECRET
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: A daily practice is not built on willpower. It is built on design."

# Slide 5 — Rule 3
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot wears a grey athletic tank top and grey athletic shorts, stands with one hand raised in a calm reassuring gesture, gentle smile.
Large bold left-aligned headline text at the top reads: NEVER MISS TWICE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Missing one day is human. Missing two starts a new habit."

# Slide 6 — Rule 4
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot wears a grey athletic tank top and grey athletic shorts, points calmly toward a meditation cushion that sits visibly in the middle of the room. The cushion is obvious and ready.
Large bold left-aligned headline text at the top reads: REMOVE THE FRICTION
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Keep the cushion in plain sight. Make starting take zero decisions."

echo ""
echo "=== Day 28 regen complete ==="
