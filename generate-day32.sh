#!/bin/bash
# Generate Day 32 slides: "Send kindness to someone who annoys you" (CHALLENGE)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day32"

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
The scene: The mascot sits cross-legged in calm meditation, eyes softly closed, a small knowing half-smile.
Large bold left-aligned headline text at the top reads: THINK OF SOMEONE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: who annoys you.
Now try this."

# Slide 2 — The premise
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands with calm relaxed posture, gentle smile, hand resting over his heart.
Large bold left-aligned headline text at the top reads: YES. THAT PERSON.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: This practice is older than the irritation.
And it works."

# Slide 3 — Why it works
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with a calm grounded smile, hands relaxed at his sides.
Large bold left-aligned headline text at the top reads: THE TRICK
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: It is not about them.
It is about freeing YOUR mind from resentment."

# Slide 4 — Step 1
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in seated meditation, hand on his own chest, soft smile, eyes gently closed.
Large bold left-aligned headline text at the top reads: STEP 1
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Start with yourself.
May I be happy.
May I be healthy."

# Slide 5 — Step 2
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot in seated meditation, hand extended outward in a gesture of offering, calm peaceful expression.
Large bold left-aligned headline text at the top reads: STEP 2
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Send it to someone neutral.
The barista. A neighbor.
May they be happy."

# Slide 6 — Step 3
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot in seated meditation, both hands open in front of him in a soft offering gesture, serene grounded expression.
Large bold left-aligned headline text at the top reads: STEP 3
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Now the difficult one.
Same phrases.
May they be happy. May they be healthy."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, soft peaceful smile, hands resting open on his knees.
Large bold left-aligned headline text at the top reads: FREE YOUR OWN MIND.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Try it once today.
At the bottom in bold text: Follow @stillmeditation for Day 33"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, soft peaceful smile, hands resting open on his knees.
Large bold left-aligned headline text at the top reads: FREE YOUR OWN MIND.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Try it once today.
At the bottom in bold text: Follow @stillmeditation.app for Day 33"

echo ""
echo "=== Day 32 Complete ==="
