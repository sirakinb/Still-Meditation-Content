#!/bin/bash
# Day 29 fixes:
#   slide 2 — typo "Four phrass" → render full word "phrases"
#   slide 5 — "May I livewith ease" → render with proper space "live with"
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day29"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm zen meditation room with wooden floors, soft natural light, green plants — UNLESS the scene calls for another setting. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

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

# Slide 2 — Title card (shorter body, force exact spelling)
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands with one hand placed gently on his own chest, calm smile, soft warm glow around him.
Render this exact text. Headline at the top in large bold left-aligned letters: LOVING-KINDNESS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text exactly: Five minutes. Four phrases. Real change.
SPELL CHECK: phrases is spelled P-H-R-A-S-E-S."

# Slide 5 — Step 3 (force space between live and with)
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in calm meditation, gentle smile, peaceful presence.
Render this exact text. Headline at the top in large bold left-aligned letters: STEP 3
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text, render exactly these three lines with a clear space between every word:
Continue:
May I be safe.
May I live with ease.
SPELL CHECK: live and with are TWO separate words with a space between them."

echo ""
echo "=== Day 29 Fix Complete ==="
