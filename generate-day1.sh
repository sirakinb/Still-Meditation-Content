#!/bin/bash
# Generate Day 1 TikTok slides for Still: Meditation
# Uses Gemini 3.1 Flash Image Preview (Nano Banana 2)

API_KEY="AIzaSyDpIU_FX8kCO8cOVlu9mf18FSG48-6NirI"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day1"

# Common style instructions for all slides
STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (like a purple Spider-Man inspired figure but without web patterns - smooth purple skin, athletic/muscular build, no visible face features except closed peaceful eyes). The art style should be clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. The background should be a warm zen meditation room with wooden floors, soft natural light, and green plants. Include the text 'Still: Meditation' in small font in the top-left corner. The overall card should have a light warm background with rounded corners. Make the text bold, large, and highly readable - designed for mobile viewing. Aspect ratio 4:5 portrait orientation for TikTok."

generate_slide() {
  local slide_num=$1
  local prompt=$2
  local filename="${OUTPUT_DIR}/slide${slide_num}.png"

  echo "Generating Slide ${slide_num}..."

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

  # Extract the base64 image data from response
  image_data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' 2>/dev/null)

  if [ -n "$image_data" ] && [ "$image_data" != "null" ]; then
    echo "$image_data" | base64 -d > "$filename"
    echo "  Saved: $filename"
  else
    echo "  ERROR generating slide ${slide_num}"
    echo "$response" | jq '.candidates[0].content.parts[] | select(.text) | .text' 2>/dev/null
    # Save error response for debugging
    echo "$response" > "${OUTPUT_DIR}/slide${slide_num}_error.json"
  fi

  # Small delay to avoid rate limiting
  sleep 2
}

# Check for jq
if ! command -v jq &> /dev/null; then
  echo "jq is required. Install with: brew install jq"
  exit 1
fi

echo "=== Generating Day 1: What Meditation Actually Is ==="
echo ""

# SLIDE 1 — THE HOOK
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: A muscular purple humanoid mascot character is sitting cross-legged in a meditation pose on a dark cushion. Above his head floats a giant glowing question mark symbol. His expression shows curiosity/wonder with eyes slightly open.

The large bold headline text reads: 'MEDITATION ISN'T WHAT YOU THINK IT IS' — the text should be in heavy black bold font, positioned at the top of the card, very large and impactful for mobile viewing.

Small 'Still: Meditation' branding text in the top-left corner."

# SLIDE 2 — THE MISCONCEPTION
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a strained, struggling meditation pose — face scrunched up in effort, with multiple chaotic colorful thought bubbles swirling around his head showing random symbols and chaos. He looks frustrated and overwhelmed trying to meditate.

The large bold headline text reads: 'MOST PEOPLE THINK MEDITATION MEANS...' at the top in heavy black bold font.

Below in slightly smaller but still bold text, a list:
• Clearing your mind completely
• Sitting perfectly still
• Feeling instant bliss
• Thinking about nothing

Small 'Still: Meditation' branding text in the top-left corner."

# SLIDE 3 — THE REALITY
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting calmly in a peaceful cross-legged meditation pose. There is a single small thought bubble gently floating away from his head, symbolizing a wandering thought being released. His expression is serene and relaxed with closed eyes. The atmosphere is calm and zen.

The large bold headline text reads: 'HERE'S WHAT IT ACTUALLY IS' at the top in heavy black bold font.

Below in medium bold text: 'Meditation is the practice of NOTICING when your mind wanders — then gently bringing it back.'

The word NOTICING should be emphasized/highlighted.

Small 'Still: Meditation' branding text in the top-left corner."

# SLIDE 4 — THE ANALOGY
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is doing a strong flexing/bicep curl pose, but instead of holding a dumbbell, he is curling a glowing neon brain icon — as if doing bicep curls with a brain. This is a fun visual metaphor showing meditation is like exercise for your brain. The mascot looks confident and powerful.

The large bold headline text reads: 'THINK OF IT LIKE BICEP CURLS FOR YOUR BRAIN' at the top in heavy black bold font.

Below in medium bold text: 'Every time your mind wanders and you bring it back — that is one rep. The wandering IS the workout.'

Small 'Still: Meditation' branding text in the top-left corner."

# SLIDE 5 — THE PERMISSION
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a peaceful cross-legged meditation pose on a dark cushion. He has a subtle glowing halo ring floating above his head (the signature Still: Meditation halo). His expression is completely serene and at peace with closed eyes. Warm golden light surrounds him.

The large bold headline text reads: 'YOU CAN'T FAIL AT MEDITATION' at the top in heavy black bold font.

Below in medium bold text: 'If you noticed your mind wandered — congratulations. That moment of awareness IS meditation working.'

Small 'Still: Meditation' branding text in the top-left corner."

# SLIDE 6 — THE PROOF
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is standing in a confident pose, pointing with one hand toward a simple clean line graph that shows a downward trending line (representing stress decreasing). The graph is minimal and clean with a clear downward slope. The mascot looks knowledgeable and authoritative.

The large bold headline text reads: 'THE SCIENCE AGREES' at the top in heavy black bold font.

Below in medium bold text: 'Research shows even 5 minutes of daily practice can reduce stress by up to 32% in 30 days.'

Below that in slightly smaller text: 'The bar is lower than you think.'

Small 'Still: Meditation' branding text in the top-left corner."

# SLIDE 7 — THE CTA
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a perfect meditation pose with eyes closed. A single flowing breath line (like a gentle sine wave) flows from his nose/mouth area, illustrating calm breathing. The subtle signature halo ring glows above his head. The atmosphere is peaceful and inviting. A small subtle App Store badge icon is in the bottom corner.

The large bold headline text reads: 'YOUR JOURNEY STARTS WITH ONE BREATH' at the top in heavy black bold font.

Below in medium bold text: 'Follow @stillmeditation for Day 2'

Below that: 'Ready to start now? Still: Meditation is free on the App Store'

A small purple meditation emoji or icon near the bottom.

Small 'Still: Meditation' branding text in the top-left corner."

echo ""
echo "=== Generation complete! ==="
echo "Check ${OUTPUT_DIR}/ for your slides."
