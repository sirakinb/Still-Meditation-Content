#!/bin/bash
# Regenerate slides 3, 6, 7 with fixed text
# No "Still: Meditation" text — logo will be overlaid separately

API_KEY="AIzaSyDpIU_FX8kCO8cOVlu9mf18FSG48-6NirI"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day1"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (like a purple Spider-Man inspired figure but without web patterns - smooth purple skin, athletic/muscular build, no visible face features except closed peaceful eyes). The art style should be clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. The background should be a warm zen meditation room with wooden floors, soft natural light, and green plants. DO NOT include any text branding or logo in the top-left corner - leave that area clean for a logo overlay. The overall card should have a light warm background with rounded corners. Make the text bold, large, and highly readable - designed for mobile viewing. Aspect ratio 4:5 portrait orientation for TikTok."

generate_slide() {
  local slide_num=$1
  local prompt=$2
  local filename="${OUTPUT_DIR}/slide${slide_num}.png"

  echo "Regenerating Slide ${slide_num}..."

  response=$(curl -s -X POST "${ENDPOINT}" \
    -H "x-goog-api-key: ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{
      \"contents\": [{
        \"parts\": [{\"text\": $(echo "$prompt" | jq -Rs .)}]
      }],
      \"generationConfig\": {
        \"responseModalities\": [\"TEXT\", \"IMAGE\"]
      }
    }")

  image_data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' 2>/dev/null)

  if [ -n "$image_data" ] && [ "$image_data" != "null" ]; then
    echo "$image_data" | base64 -d > "$filename"
    echo "  Saved: $filename"
  else
    echo "  ERROR generating slide ${slide_num}"
    echo "$response" > "${OUTPUT_DIR}/slide${slide_num}_error.json"
  fi
}

# SLIDE 3 — THE REALITY (fix "youn your" typo)
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting calmly in a peaceful cross-legged meditation pose. There is a single small thought bubble gently floating away from his head, symbolizing a wandering thought being released. His expression is serene and relaxed with closed eyes. The atmosphere is calm and zen.

The large bold headline text at the top reads: HERE'S WHAT IT ACTUALLY IS

Below in medium bold text: Meditation is the practice of NOTICING when your mind wanders — then gently bringing it back.

The word NOTICING should be emphasized/highlighted. Do NOT include any branding text in the top-left corner."

sleep 2

# SLIDE 6 — THE PROOF (fix duplicated "you think" text)
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is standing in a confident pose, pointing with one hand toward a simple clean line graph that shows a downward trending line representing stress decreasing over time. The graph is minimal and clean. The mascot looks knowledgeable and authoritative.

The large bold headline text at the top reads: THE SCIENCE AGREES

Below in medium bold text: Research shows even 5 minutes of daily practice can reduce stress by up to 32% in 30 days.

Below that in slightly smaller text: The bar is lower than you think.

Do NOT duplicate any text. Do NOT include any branding text in the top-left corner."

sleep 2

# SLIDE 7 — THE CTA (fix "STARTTS" typo, remove mini mascot at bottom)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a perfect meditation pose with eyes closed. A single flowing breath line (like a gentle sine wave) flows from his nose area, illustrating calm breathing. The subtle signature halo ring glows above his head. The atmosphere is peaceful and inviting.

IMPORTANT: Only show ONE instance of the purple mascot. Do NOT add any miniature or small version of the mascot anywhere. No small icons of the character. No App Store badge.

The large bold headline text at the top reads: YOUR JOURNEY STARTS WITH ONE BREATH

Below in medium bold text: Follow @stillmeditation for Day 2

Below that: Ready to start now? Still: Meditation is free on the App Store

Do NOT include any branding text in the top-left corner. Do NOT include any small mascot icon at the bottom."

echo ""
echo "=== Regeneration complete ==="
