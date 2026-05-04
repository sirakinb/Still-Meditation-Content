#!/bin/bash
# Generate Day 33 slides: "You're not meditating wrong — you're building something" (MOTIVATION)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day33"

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
The scene: The mascot sits cross-legged in calm meditation, eyes softly closed, a small peaceful smile, glow of warm morning light around him.
Large bold left-aligned headline text at the top reads: YOU ARE NOT
MEDITATING WRONG.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You are building something."

# Slide 2 — The doubt
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands with a gentle reassuring smile, one hand raised in a calm 'it is okay' gesture.
Large bold left-aligned headline text at the top reads: THE DOUBT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: My mind still wanders.
I am still restless.
This is not working."

# Slide 3 — The reframe
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with a calm grounded smile, arms relaxed, soft confident posture.
Large bold left-aligned headline text at the top reads: THE TRUTH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Meditation is not arrival.
It is training."

# Slide 4 — Month 1
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot in a strong grounded standing pose, flexing one arm gently, calm focused expression.
Large bold left-aligned headline text at the top reads: MONTH 1
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You built the
attention muscle."

# Slide 5 — Month 2
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in calm meditation, hand resting over his heart, soft warm smile.
Large bold left-aligned headline text at the top reads: MONTH 2
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: That muscle is
learning new skills."

# Slide 6 — Both are meditation
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot in seated meditation, one hand on his head and one on his heart, peaceful balanced expression.
Large bold left-aligned headline text at the top reads: FROM FOCUS
TO FEELING.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Both are meditation.
Both are you growing."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, soft peaceful smile, hands resting open on his knees, warm light streaming in.
Large bold left-aligned headline text at the top reads: KEEP SHOWING UP.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You are already there.
At the bottom in bold text: Follow @stillmeditation for Day 34"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, soft peaceful smile, hands resting open on his knees, warm light streaming in.
Large bold left-aligned headline text at the top reads: KEEP SHOWING UP.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You are already there.
At the bottom in bold text: Follow @stillmeditation.app for Day 34"

echo ""
echo "=== Day 33 Complete ==="
