#!/bin/bash
# Regen Day 23 pass 2 — fix slide 7 TikTok "Line" artifact in body text
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day23"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm outdoor path with soft natural light and green plants. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

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

# Fix Slide 7 — remove line labels, keep body copy tight
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall at the start of a winding path, relaxed and ready to walk. One foot slightly forward. Expression is open, grounded, inviting. Calm outdoor light.
TOP of card: large bold left-aligned headline text that reads exactly: YOUR TURN.
LEAVE A CLEAR GAP between headline and body text.
BODY TEXT below the gap — render ONLY these 4 short lines, nothing else, no extra words:
10 minutes.
Slow steps.
Feel lifting, moving, placing.
No cushion required.
BOTTOM of card: bold centered text that reads exactly: Follow @stillmeditation for Day 24"

echo ""
echo "=== Day 23 Regen Fix 2 Complete ==="
