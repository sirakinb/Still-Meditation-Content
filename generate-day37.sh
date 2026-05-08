#!/bin/bash
# Generate Day 37 slides: "The immune system boost you didn't know breathwork gives you" (SCIENCE)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day37"

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
The scene: The mascot stands tall and confident, taking a deep breath, chest expanded, soft warm glow radiating outward from his torso suggesting energy and vitality.
Large bold left-aligned headline text at the top reads: BREATHWORK HACKS YOUR IMMUNE SYSTEM.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: This is not woo.
2014 PNAS study.
Real numbers."

# Slide 2 — The study
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands in a calm science lab setting, looking thoughtful and curious, soft natural light.
Large bold left-aligned headline text at the top reads: THE STUDY
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 24 volunteers.
Endotoxin injected.
Trained group barely reacted."

# Slide 3 — The numbers
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands strong and grounded, calm confident expression, soft warm light around him.
Large bold left-aligned headline text at the top reads: THE NUMBERS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 200% more
anti-inflammatory.
50% less inflammation."

# Slide 4 — The mechanism
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in calm meditation, taking a deep breath, eyes softly closed, peaceful focused expression.
Large bold left-aligned headline text at the top reads: HOW IT WORKS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Fast breathing
spikes adrenaline.
Adrenaline calms inflammation."

# Slide 5 — Why it matters
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall with hand on chest, calm confident expression, soft warm light.
Large bold left-aligned headline text at the top reads: WHY IT MATTERS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You can shift
your blood chemistry.
With your breath."

# Slide 6 — The protocol
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged on a cushion, eyes closed, mid breath, calm and steady, soft natural light.
Large bold left-aligned headline text at the top reads: THE PROTOCOL
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 30 deep breaths.
Hold the exhale.
3 rounds. 10 minutes."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with chest open, taking a powerful deep breath, soft warm glow radiating outward suggesting strength and vitality.
Large bold left-aligned headline text at the top reads: BREATHE STRONGER.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 10 minutes.
Real biology.
At the bottom in bold text: Follow @stillmeditation for Day 38"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with chest open, taking a powerful deep breath, soft warm glow radiating outward suggesting strength and vitality.
Large bold left-aligned headline text at the top reads: BREATHE STRONGER.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 10 minutes.
Real biology.
At the bottom in bold text: Follow @stillmeditation.app for Day 38"

echo ""
echo "=== Day 37 Complete ==="
