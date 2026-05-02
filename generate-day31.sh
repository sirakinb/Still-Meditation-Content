#!/bin/bash
# Generate Day 31 slides: "Alternate nostril breathing: ancient technique, modern science" (TUTORIAL)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day31"

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
The scene: The mascot sits cross-legged in calm meditation, right hand raised near his nose in the alternate nostril breathing mudra, peaceful expression.
Large bold left-aligned headline text at the top reads: 3,000 YEARS OLD.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: One breath technique. Both brain hemispheres."

# Slide 2 — The science
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands with a calm confident smile, hand on chest.
Large bold left-aligned headline text at the top reads: THE SCIENCE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: It balances your sympathetic and parasympathetic nervous systems."

# Slide 3 — Step 1
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot uses his right thumb to close his right nostril, eyes softly closed, calm focused expression.
Large bold left-aligned headline text at the top reads: STEP 1
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Right thumb closes the right nostril.
Inhale slowly through the left."

# Slide 4 — Step 2
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot uses his right ring finger to close his left nostril, calm focused expression.
Large bold left-aligned headline text at the top reads: STEP 2
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Ring finger closes the left nostril.
Exhale slowly through the right."

# Slide 5 — Step 3
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot inhales through the right nostril, ring finger still closing the left, calm posture.
Large bold left-aligned headline text at the top reads: STEP 3
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Inhale right.
Switch fingers. Exhale left.
That is one cycle."

# Slide 6 — The dose
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits calmly in lotus pose, soft warm glow, grounded smile.
Large bold left-aligned headline text at the top reads: THE DOSE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Five to ten minutes.
Heart rate drops.
Mind clears."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, hand near his nose in the breathing mudra, soft peaceful smile.
Large bold left-aligned headline text at the top reads: ANCIENT TECH. PROVEN BENEFITS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Try it once today.
At the bottom in bold text: Follow @stillmeditation for Day 32"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, hand near his nose in the breathing mudra, soft peaceful smile.
Large bold left-aligned headline text at the top reads: ANCIENT TECH. PROVEN BENEFITS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Try it once today.
At the bottom in bold text: Follow @stillmeditation.app for Day 32"

echo ""
echo "=== Day 31 Complete ==="
