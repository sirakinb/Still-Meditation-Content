#!/bin/bash
# Generate Day 26 slides: "The mindful meal challenge" (CHALLENGE)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day26"

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
The scene: The mascot sits at a small wooden table with a simple bowl of food in front of him. His phone is face-down off to the side. He looks down at the food with calm focus. Warm soft lighting.
Large bold left-aligned headline text at the top reads: EAT ONE MEAL TODAY WITHOUT YOUR PHONE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Here's how."

# Slide 2 — Title card
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits cross-legged with a small bowl in his hands. His expression is calm and focused. A small fork icon and a subtle leaf float beside him on the right.
Large bold left-aligned headline text at the top reads: THE MINDFUL MEAL CHALLENGE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Meditation without a cushion. Just you and your food."

# Slide 3 — Why it matters
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with a thoughtful, slightly surprised expression. A small phone with a red X is shown only on the right side near him.
Large bold left-aligned headline text at the top reads: WHY THIS MATTERS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Most people scroll through every meal. You taste nothing. You stay hungry. One phone-free meal resets the whole pattern."

# Slide 4 — Step 1: Before
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits at a table with a bowl of food in front of him. His eyes are softly closed and he's mid-inhale. Hands rest gently on the table. A subtle breath wave near his nose.
Large bold left-aligned headline text at the top reads: STEP 1: BEFORE THE FIRST BITE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Take three slow breaths. Look at your food. That's it."

# Slide 5 — Step 2: During
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot holds a fork mid-bite, his eyes soft and focused on the food. Expression is curious and present.
Large bold left-aligned headline text at the top reads: STEP 2: TASTE THE BITE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Notice texture. Notice temperature. Notice flavor. Chew slowly."

# Slide 6 — Step 3: Reset between bites
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot calmly sets his fork down on the side of his plate. His hands rest on the table. Expression is patient and settled.
Large bold left-aligned headline text at the top reads: STEP 3: PUT THE FORK DOWN
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Between every bite, set utensils down. When the mind pulls toward your phone, return to the food."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits at a small wooden table with an empty bowl in front of him. He looks calm, satisfied, slightly smiling. Soft warm light around him.
Large bold left-aligned headline text at the top reads: TRY IT TODAY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: One meal. No phone. Three breaths before. Slow chews. Fork down between bites.
At the bottom in bold text: Follow @stillmeditation for Day 27"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits at a small wooden table with an empty bowl in front of him. He looks calm, satisfied, slightly smiling. Soft warm light around him.
Large bold left-aligned headline text at the top reads: TRY IT TODAY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: One meal. No phone. Three breaths before. Slow chews. Fork down between bites.
At the bottom in bold text: Follow @stillmeditation.app for Day 27"

echo ""
echo "=== Day 26 Complete ==="
