#!/bin/bash
# Generate Day 27 slides: "The best meditators in the world get distracted constantly" (MYTH)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day27"

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
The scene: The mascot sits cross-legged in meditation. His expression is calm but his eyes are open, looking slightly to the side as if a thought just passed through. Soft warm light. Subtle thought bubbles drift around his head.
Large bold left-aligned headline text at the top reads: MONKS GET DISTRACTED TOO.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Yes, even the ones with 50,000 hours of practice."

# Slide 2 — Title card
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits in lotus pose with a calm half-smile. His eyes are softly open. A small thought cloud floats near him on the right side.
Large bold left-aligned headline text at the top reads: THE MEDITATION MYTH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: A quiet mind is not the goal."

# Slide 3 — The lie
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot looks frustrated, hand on his forehead. A small tangled scribble cloud hovers near him on the right.
Large bold left-aligned headline text at the top reads: WHAT YOU THINK
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Good meditators have empty minds. You keep getting distracted, so you must be bad at this."

# Slide 4 — The truth
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits calmly with eyes open, gentle smile, hands resting on his knees. A small open book or scroll floats beside him on the right.
Large bold left-aligned headline text at the top reads: THE TRUTH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Brain scans of expert monks show wandering minds. Constantly."

# Slide 5 — The real skill
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation. His eyes are softly open. A small lightbulb glows near his head on the right side.
Large bold left-aligned headline text at the top reads: THE REAL SKILL
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Not fewer distractions. Faster noticing."

# Slide 6 — The reframe
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands confidently with one hand raised in a calm pointing gesture. Expression is reassuring and grounded.
Large bold left-aligned headline text at the top reads: EVERY TIME YOU NOTICE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: That is the rep. The catch is the practice. Not the quiet."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in meditation, eyes softly closed, calm smile. Soft warm light around him.
Large bold left-aligned headline text at the top reads: STOP CHASING SILENCE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Start counting catches. That is meditation.
At the bottom in bold text: Follow @stillmeditation for Day 28"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in meditation, eyes softly closed, calm smile. Soft warm light around him.
Large bold left-aligned headline text at the top reads: STOP CHASING SILENCE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Start counting catches. That is meditation.
At the bottom in bold text: Follow @stillmeditation.app for Day 28"

echo ""
echo "=== Day 27 Complete ==="
