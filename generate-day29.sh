#!/bin/bash
# Generate Day 29 slides: "Loving-kindness: the meditation that changes how you feel about yourself" (TUTORIAL)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day29"

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
The scene: The mascot sits cross-legged in meditation, hands resting gently on knees, soft smile, eyes closed peacefully. Warm light surrounds him.
Large bold left-aligned headline text at the top reads: KINDNESS IS A SKILL.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: This meditation literally rewires how you feel about yourself."

# Slide 2 — Title card
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands with one hand placed gently on his own chest, calm smile, soft warm glow around him.
Large bold left-aligned headline text at the top reads: LOVING-KINDNESS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: A 5-minute practice. Four phrases. Real change."

# Slide 3 — Step 1 (Sit + breathe)
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged on a cushion with eyes closed, taking a calm slow breath.
Large bold left-aligned headline text at the top reads: STEP 1
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Sit quietly. Close your eyes. Breathe slowly."

# Slide 4 — Step 2 (First two phrases)
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation, one hand placed softly over his heart.
Large bold left-aligned headline text at the top reads: STEP 2
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Repeat silently:
May I be happy.
May I be healthy."

# Slide 5 — Step 3 (Next two phrases)
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in calm meditation, gentle smile, peaceful presence.
Large bold left-aligned headline text at the top reads: STEP 3
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Continue:
May I be safe.
May I live with ease."

# Slide 6 — Step 4 (Feel it)
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with both hands on his chest, soft warm glow radiating outward, calm closed eyes.
Large bold left-aligned headline text at the top reads: STEP 4
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Feel each word land. Do not just think it."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, soft smile, peaceful glow around him.
Large bold left-aligned headline text at the top reads: SEVEN WEEKS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: That is how long it takes to feel the shift.
At the bottom in bold text: Follow @stillmeditation for Day 30"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, soft smile, peaceful glow around him.
Large bold left-aligned headline text at the top reads: SEVEN WEEKS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: That is how long it takes to feel the shift.
At the bottom in bold text: Follow @stillmeditation.app for Day 30"

echo ""
echo "=== Day 29 Complete ==="
