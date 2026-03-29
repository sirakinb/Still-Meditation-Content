#!/bin/bash
# Regenerate slides 1, 2, 4, 5 with clean top-left corner (no text branding)

API_KEY="AIzaSyDpIU_FX8kCO8cOVlu9mf18FSG48-6NirI"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day1"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (like a purple Spider-Man inspired figure but without web patterns - smooth purple skin, athletic/muscular build, no visible face features except closed peaceful eyes). The art style should be clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. The background should be a warm zen meditation room with wooden floors, soft natural light, and green plants. DO NOT include any text branding, logo, or watermark in the top-left corner — leave that area completely clean and empty for a logo overlay later. The overall card should have a light warm background with rounded corners. Make the text bold, large, and highly readable - designed for mobile viewing. Aspect ratio 4:5 portrait orientation for TikTok."

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

  sleep 2
}

# SLIDE 1 — THE HOOK
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: A muscular purple humanoid mascot character is sitting cross-legged in a meditation pose on a dark cushion. Above his head floats a giant glowing question mark symbol. His expression shows curiosity with eyes slightly open.

The large bold headline text reads: MEDITATION ISN'T WHAT YOU THINK IT IS — positioned at the top of the card in heavy black bold font, very large and impactful.

Do NOT include any branding text or logo anywhere on the image."

# SLIDE 2 — THE MISCONCEPTION
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a strained, struggling meditation pose — face scrunched up in effort, with multiple chaotic colorful thought bubbles swirling around his head showing random symbols and chaos. He looks frustrated trying to meditate.

The large bold headline text reads: MOST PEOPLE THINK MEDITATION MEANS... at the top in heavy black bold font.

Below in slightly smaller but still bold text, a bullet list:
- Clearing your mind completely
- Sitting perfectly still
- Feeling instant bliss
- Thinking about nothing

Do NOT include any branding text or logo anywhere on the image."

# SLIDE 4 — THE ANALOGY
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is doing a strong flexing bicep curl pose, but instead of holding a dumbbell, he is curling a glowing neon brain icon — as if doing bicep curls with a brain. This is a fun visual metaphor showing meditation is like exercise for your brain. The mascot looks confident and powerful.

The large bold headline text reads: THINK OF IT LIKE BICEP CURLS FOR YOUR BRAIN at the top in heavy black bold font.

Below in medium bold text: Every time your mind wanders and you bring it back — that is one rep. The wandering IS the workout.

Do NOT include any branding text or logo anywhere on the image."

# SLIDE 5 — THE PERMISSION
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a peaceful cross-legged meditation pose on a dark cushion. He has a subtle glowing halo ring floating above his head. His expression is completely serene and at peace with closed eyes. Warm golden light surrounds him.

The large bold headline text reads: YOU CAN'T FAIL AT MEDITATION at the top in heavy black bold font.

Below in medium bold text: If you noticed your mind wandered — congratulations. That moment of awareness IS meditation working.

Do NOT include any branding text or logo anywhere on the image."

echo ""
echo "=== Regeneration complete ==="
