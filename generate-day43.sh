#!/bin/bash
# Generate Day 43 slides: "Your heart rate variability is your stress scorecard" (SCIENCE)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day43"

mkdir -p "$OUTPUT_DIR"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm zen meditation room with wooden floors, soft natural light, green plants — UNLESS the scene calls for another setting. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

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

# Slide 1 — Hook
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, hand on chest, calm focused expression. Subtle soft glow pulse near his chest suggesting a heartbeat.
Large bold left-aligned headline text at the top reads: ONE NUMBER PREDICTS YOUR STRESS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: It is not your heart rate.
It is something better."

# Slide 2 — Meet HRV
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands looking thoughtful, slight smile, calm composed posture.
Large bold left-aligned headline text at the top reads: MEET HRV
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Heart rate variability.
The tiny gaps
between heartbeats."

# Slide 3 — Why it matters
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands strong and grounded, calm steady expression, soft warm light.
Large bold left-aligned headline text at the top reads: WHY IT MATTERS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Higher HRV.
Better stress recovery.
Lower HRV. Burnout signal."

# Slide 4 — The study
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands in a calm science lab setting, looking curious, soft natural light.
Large bold left-aligned headline text at the top reads: THE 2022 STUDY
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 4 weeks.
20 minutes a day.
HRV up. Stress down."

# Slide 5 — The fix
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in calm meditation, eyes softly closed, peaceful focused expression mid-breath.
Large bold left-aligned headline text at the top reads: COHERENT BREATHING
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 5 in. 5 out.
6 breaths per minute.
Your nervous system resets."

# Slide 6 — The protocol
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits on a cushion, eyes closed, calm and steady mid-breath, soft natural light.
Large bold left-aligned headline text at the top reads: THE PROTOCOL
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 20 minutes daily.
4 weeks straight.
Track HRV weekly."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with chest open, hand on heart, calm confident expression, soft warm glow around him.
Large bold left-aligned headline text at the top reads: TRAIN YOUR HRV.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 20 minutes.
Real biology.
At the bottom in bold text: Follow @stillmeditation for Day 44"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with chest open, hand on heart, calm confident expression, soft warm glow around him.
Large bold left-aligned headline text at the top reads: TRAIN YOUR HRV.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 20 minutes.
Real biology.
At the bottom in bold text: Follow @stillmeditation.app for Day 44"

echo ""
echo "=== Day 43 Complete ==="
