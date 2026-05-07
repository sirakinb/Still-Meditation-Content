#!/bin/bash
# Generate Day 36 slides: "Loving-kindness level 2: the expanding circle" (TUTORIAL)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day36"

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
The scene: The mascot sits cross-legged in calm meditation, eyes softly closed, peaceful smile, soft warm glow radiating outward in concentric circles.
Large bold left-aligned headline text at the top reads: THE EXPANDING CIRCLE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: From self-compassion
to world compassion
in 10 minutes."

# Slide 2 — Circle 1: Yourself
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits cross-legged with hand resting gently on his own chest, soft smile, eyes closed.
Large bold left-aligned headline text at the top reads: START WITH YOU
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 2 minutes.
May I be safe.
May I be happy."

# Slide 3 — Circle 2: Loved one
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in calm meditation, soft smile, eyes closed, warm light glowing around him.
Large bold left-aligned headline text at the top reads: A LOVED ONE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 2 minutes.
Picture them clearly.
Send them peace."

# Slide 4 — Circle 3: Neutral person
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands calm and grounded, hands relaxed at his sides, gentle expression.
Large bold left-aligned headline text at the top reads: A STRANGER
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 2 minutes.
The barista.
The neighbor."

# Slide 5 — Circle 4: Difficult person
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in calm meditation, eyes softly closed, breathing steadily, soft warm light.
Large bold left-aligned headline text at the top reads: SOMEONE HARD
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 2 minutes.
The hardest circle.
Wish them well."

# Slide 6 — Circle 5: All beings
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in serene meditation, hands open on his knees, soft warm glow radiating outward in wide concentric circles.
Large bold left-aligned headline text at the top reads: ALL BEINGS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 2 minutes.
Everyone, everywhere.
May all be free."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion, peaceful smile, hands open on his knees, soft warm light radiating outward in concentric circles around him.
Large bold left-aligned headline text at the top reads: EXPAND THE CIRCLE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 10 minutes.
5 hearts.
At the bottom in bold text: Follow @stillmeditation for Day 37"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion, peaceful smile, hands open on his knees, soft warm light radiating outward in concentric circles around him.
Large bold left-aligned headline text at the top reads: EXPAND THE CIRCLE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 10 minutes.
5 hearts.
At the bottom in bold text: Follow @stillmeditation.app for Day 37"

echo ""
echo "=== Day 36 Complete ==="
