#!/bin/bash
# Generate Day 45 slides: "Halfway there: your 45-day meditation assessment" (CHECK-IN)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day45"

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
The scene: The mascot stands tall with calm confident posture, soft warm light, looking forward.
Large bold left-aligned headline text at the top reads: DAY 45.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Halfway.
Time to measure."

# Slide 2 — The check-in
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands with arms crossed, calm focused expression, soft natural light.
Large bold left-aligned headline text at the top reads: THE CHECK-IN
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Rate yourself
one to ten.
Four questions."

# Slide 3 — Question 1
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in meditation, eyes softly closed, calm steady posture.
Large bold left-aligned headline text at the top reads: ONE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Can you sit
ten minutes without
checking the time?"

# Slide 4 — Question 2
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands calm and grounded, thoughtful expression, soft natural light.
Large bold left-aligned headline text at the top reads: TWO
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Do you notice
thoughts before
you react?"

# Slide 5 — Question 3
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot rests calmly, looking peaceful and rested, soft warm light.
Large bold left-aligned headline text at the top reads: THREE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Has your sleep
improved?"

# Slide 6 — Question 4
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with relaxed shoulders, hand near chest in a body-awareness posture, soft natural light.
Large bold left-aligned headline text at the top reads: FOUR
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Do you catch
tension in your body
during the day?"

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with calm confident posture, soft warm glow around him.
Large bold left-aligned headline text at the top reads: HALFWAY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Several above five
means you are
right on track.
At the bottom in bold text: Follow @stillmeditation for Day 46"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with calm confident posture, soft warm glow around him.
Large bold left-aligned headline text at the top reads: HALFWAY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Several above five
means you are
right on track.
At the bottom in bold text: Follow @stillmeditation.app for Day 46"

echo ""
echo "=== Day 45 Complete ==="
