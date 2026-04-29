#!/bin/bash
# Generate Day 28 slides: "The secret to a daily practice isn't discipline — it's design" (QUICK TIP)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day28"

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
The scene: The mascot sits cross-legged on a meditation cushion placed right next to a bed in a softly lit bedroom. Morning light. He looks calm and confident. Cushion is visible and obvious.
Large bold left-aligned headline text at the top reads: DISCIPLINE IS OVERRATED.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The people who meditate daily are not more disciplined than you."

# Slide 2 — Title card
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands holding a small blueprint or design plan in one hand, calm smile, confident posture.
Large bold left-aligned headline text at the top reads: THE SECRET
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: A daily practice is not built on willpower. It is built on design."

# Slide 3 — Rule 1
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation right next to a coffee mug on a small table. A clock on the wall reads 7 AM.
Large bold left-aligned headline text at the top reads: ANCHOR IT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Same time. Same place. Attach it to a habit you already do."

# Slide 4 — Rule 2
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation. A small hourglass or timer beside him reads 2 minutes.
Large bold left-aligned headline text at the top reads: START ABSURDLY SMALL
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Two minutes. Every day. Boring is the point."

# Slide 5 — Rule 3
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with one hand raised in a calm reassuring gesture, gentle smile.
Large bold left-aligned headline text at the top reads: NEVER MISS TWICE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Missing one day is human. Missing two starts a new habit."

# Slide 6 — Rule 4
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot points calmly toward a meditation cushion that sits visibly in the middle of the room. The cushion is obvious and ready.
Large bold left-aligned headline text at the top reads: REMOVE THE FRICTION
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Keep the cushion in plain sight. Make starting take zero decisions."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in meditation on a cushion in a sunlit room. Calm smile. The cushion is clearly visible and inviting.
Large bold left-aligned headline text at the top reads: DESIGN BEATS DISCIPLINE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Build the system. The streak builds itself.
At the bottom in bold text: Follow @stillmeditation for Day 29"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in meditation on a cushion in a sunlit room. Calm smile. The cushion is clearly visible and inviting.
Large bold left-aligned headline text at the top reads: DESIGN BEATS DISCIPLINE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Build the system. The streak builds itself.
At the bottom in bold text: Follow @stillmeditation.app for Day 29"

echo ""
echo "=== Day 28 Complete ==="
