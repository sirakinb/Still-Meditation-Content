#!/bin/bash
# Generate Day 30 slides: "Loving-kindness meditation lights up your brain like nothing else" (SCIENCE)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day30"

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
The scene: The mascot sits cross-legged in meditation, soft glow radiating from his head, peaceful smile, eyes closed.
Large bold left-aligned headline text at the top reads: YOUR BRAIN ON KINDNESS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: One meditation lights it up like nothing else."

# Slide 2 — The claim
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands with a calm confident smile, hand on chest.
Large bold left-aligned headline text at the top reads: THE STUDY
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: fMRI scans of loving-kindness meditators reveal three big changes."

# Slide 3 — Insula
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in calm meditation, gentle smile, soft warm glow.
Large bold left-aligned headline text at the top reads: 1. THE INSULA
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The empathy center fires harder.
You feel others more clearly."

# Slide 4 — TPJ
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot meditates with a thoughtful peaceful expression.
Large bold left-aligned headline text at the top reads: 2. THE TPJ
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Perspective-taking gets sharper.
You see past your own head."

# Slide 5 — Amygdala
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits calmly with shoulders relaxed, soft confident smile.
Large bold left-aligned headline text at the top reads: 3. THE AMYGDALA
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Threat reactivity drops.
You stop bracing for impact."

# Slide 6 — The real-world result
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall with a warm grounded smile, calm posture.
Large bold left-aligned headline text at the top reads: THE RESULT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: More compassion.
Less implicit bias.
Measurable in weeks."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, soft smile, peaceful glow around him.
Large bold left-aligned headline text at the top reads: KINDNESS RESHAPES THE BRAIN.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Practice it like a muscle.
At the bottom in bold text: Follow @stillmeditation for Day 31"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, soft smile, peaceful glow around him.
Large bold left-aligned headline text at the top reads: KINDNESS RESHAPES THE BRAIN.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Practice it like a muscle.
At the bottom in bold text: Follow @stillmeditation.app for Day 31"

echo ""
echo "=== Day 30 Complete ==="
