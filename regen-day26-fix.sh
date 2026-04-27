#!/bin/bash
# Regen Day 26 slides 6 and 7 — fix text issues
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day26"

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

# Slide 6 — Step 3: shorter body, explicit text
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot calmly sets his fork down beside a plate. His hands rest on the table. Expression is patient and settled.
Render exactly this text and nothing else.
Large bold left-aligned headline text at the top reads: STEP 3: FORK DOWN
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text exactly as written:
Set utensils down between every bite.
Return to the food when the mind drifts."

# Slide 7 — TikTok variant, shorter body to avoid mascot overlap
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits at a small wooden table with an empty bowl. He looks calm and slightly smiling. Soft warm light around him.
Render exactly this text and nothing else.
Large bold left-aligned headline text at the top reads: TRY IT TODAY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text exactly as written:
One meal.
No phone.
Three breaths first.
Slow chews.
At the bottom in bold text exactly as written: Follow @stillmeditation for Day 27"

echo ""
echo "=== Regen complete ==="
