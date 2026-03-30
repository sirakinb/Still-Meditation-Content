#!/bin/bash
# Generate Day 3 TikTok slides: "What 10 Minutes of Meditation Does to Your Brain"

API_KEY="AIzaSyBmX1veSvUoBCHMYUTSGlVwZKHlxZHY7z8"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day3"

mkdir -p "$OUTPUT_DIR"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Background: warm zen meditation room with wooden floors, soft natural light, green plants. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation for TikTok. Only ONE instance of the mascot per image — never add miniature versions or icons of the character."

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

  image_data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' 2>/dev/null)

  if [ -n "$image_data" ] && [ "$image_data" != "null" ]; then
    echo "$image_data" | base64 -d > "$filename"
    echo "  Saved: $filename"
  else
    echo "  ERROR generating slide ${slide_num}"
    echo "$response" | jq '.error' > "${OUTPUT_DIR}/slide${slide_num}_error.json"
  fi

  sleep 2
}

echo "=== Generating Day 3: What 10 Minutes of Meditation Does to Your Brain ==="
echo ""

# SLIDE 1 — HOOK
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting cross-legged in meditation pose, looking upward with wide eyes full of awe and wonder. Above his head floats a large glowing human brain illustration — bright, luminous, pulsing with soft light. The brain looks impressive and scientific, not cartoonish.

Large bold left-aligned headline text at the top reads: YOUR BRAIN PHYSICALLY CHANGES WHEN YOU MEDITATE

Below in medium bold text: And science can prove it."

# SLIDE 2 — THE CLAIM
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting confidently, holding a clipboard or notepad with scientific-looking data on it. He is wearing a casual lab coat over his muscular frame or holding scientific equipment. His expression is confident and authoritative. The background has subtle scientific elements like charts or molecular patterns.

Large bold left-aligned headline text at the top reads: THIS IS NOT SPIRITUAL. IT IS SCIENCE.

Below in medium bold text: Brain scans. Peer-reviewed studies. Real data."

# SLIDE 3 — FACT 1: HIPPOCAMPUS
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in meditation with a large glowing brain illustration above or beside him. The hippocampus region of the brain is highlighted in a bright color (gold or green) with an upward arrow next to it showing growth. The rest of the brain is in muted tones. The visual clearly shows one specific region growing bigger.

Large bold left-aligned headline text at the top reads: 8 WEEKS OF MEDITATION GROWS YOUR HIPPOCAMPUS

Below in medium bold text: That is your learning and memory center. It literally gets bigger."

# SLIDE 4 — FACT 2: AMYGDALA
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting peacefully in meditation with a calm expression. Beside or above him is a brain illustration with the amygdala region highlighted in red with a downward arrow showing it shrinking. A small stress or fear icon (lightning bolt or skull) is also shrinking. The contrast between the calm mascot and the shrinking stress center is clear.

Large bold left-aligned headline text at the top reads: YOUR AMYGDALA ACTUALLY SHRINKS

Below in medium bold text: That is your fear and stress center. Less reactivity. Less anxiety."

# SLIDE 5 — FACT 3: 32% LESS STRESS
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting relaxed with a visibly calm, peaceful expression — shoulders relaxed, slight smile. Beside him is a bold stress meter or gauge graphic showing a needle dropping from high stress (red zone) down to low stress (green zone). A bold number 32% is prominently displayed. The overall vibe is relief and calm.

Large bold left-aligned headline text at the top reads: 30 DAYS = 32% LESS STRESS

Below in medium bold text: Headspace research. 30 days of meditation. Measured and proven."

# SLIDE 6 — THE PUNCHLINE
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a simple meditation pose looking directly forward with a calm confident expression. Above him the glowing brain is visible again. A simple clock or timer showing 10:00 is visible nearby. The composition feels empowering — the mascot looks like he knows a secret the viewer needs to hear.

Large bold left-aligned headline text at the top reads: 10 MINUTES A DAY DOES ALL OF THIS

Below in medium bold text: No hour-long sessions. No retreat. No special equipment. Just 10 minutes."

# SLIDE 7 — CTA (TikTok)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a relaxed meditation pose with a knowing smirk — confident and a little playful. He has one eyebrow slightly raised as if saying 'told you so.' The halo ring glows subtly above his head. The atmosphere is warm and inviting.

IMPORTANT: Only ONE mascot. No mini versions. No App Store badges.

Large bold left-aligned headline text at the top reads: SAVE THIS AND SHOW IT TO SOMEONE WHO THINKS MEDITATION IS JUST VIBES

Below in medium bold text: Follow @stillmeditation for Day 4: the 1-minute breathing challenge."

sleep 2

# SLIDE 7 — Instagram version
echo "Generating Slide 7 (Instagram version)..."

PROMPT_IG="Create a bold TikTok social media card illustration. ${STYLE} The scene: The muscular purple humanoid mascot is sitting in a relaxed meditation pose with a knowing smirk — confident and a little playful. He has one eyebrow slightly raised as if saying told you so. The halo ring glows subtly above his head. The atmosphere is warm and inviting. IMPORTANT: Only ONE mascot. No mini versions. No App Store badges. Large bold left-aligned headline text at the top reads: SAVE THIS AND SHOW IT TO SOMEONE WHO THINKS MEDITATION IS JUST VIBES. Below in medium bold text: Follow @stillmeditation.app for Day 4: the 1-minute breathing challenge."

response=$(curl -s -X POST "${ENDPOINT}" \
  -H "x-goog-api-key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"contents\": [{
      \"parts\": [{\"text\": $(echo "$PROMPT_IG" | jq -Rs .)}]
    }],
    \"generationConfig\": {
      \"responseModalities\": [\"TEXT\", \"IMAGE\"]
    }
  }")

image_data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' 2>/dev/null)

if [ -n "$image_data" ] && [ "$image_data" != "null" ]; then
  echo "$image_data" | base64 -d > "${OUTPUT_DIR}/slide7_instagram.png"
  echo "  Saved: ${OUTPUT_DIR}/slide7_instagram.png"
else
  echo "  ERROR generating Instagram slide 7"
fi

echo ""
echo "=== Day 3 generation complete! ==="
echo "Check ${OUTPUT_DIR}/ for your slides."
