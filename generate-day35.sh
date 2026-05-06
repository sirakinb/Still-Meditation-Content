#!/bin/bash
# Generate Day 35 slides: "5 weeks in and you probably haven't noticed the biggest changes" (CHECK-IN)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day35"

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
The scene: The mascot sits cross-legged in calm meditation, eyes softly closed, peaceful smile, soft warm light around him.
Large bold left-aligned headline text at the top reads: 5 WEEKS IN.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You probably haven't noticed
the biggest changes."

# Slide 2 — The blind spot
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands with a calm thoughtful look, one hand near his chin.
Large bold left-aligned headline text at the top reads: WHY YOU MISS IT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The changes are quiet.
Internal.
You normalize them fast."

# Slide 3 — Others notice first
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with a calm grounded smile, arms relaxed at his sides.
Large bold left-aligned headline text at the top reads: OTHERS NOTICE FIRST
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Less reactive.
More patient.
Calmer in conflict."

# Slide 4 — The pause
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands calm and centered, eyes open, one hand raised gently as if pausing.
Large bold left-aligned headline text at the top reads: THE PAUSE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: A half-second gap
before you respond.
That gap is everything."

# Slide 5 — Anxiety shift
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in calm meditation, eyes softly closed, soft warm glow around his chest.
Large bold left-aligned headline text at the top reads: ANXIETY SHIFTS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Not gone.
Just a quiet hum
in the background."

# Slide 6 — The turn
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in serene meditation, peaceful smile, hands resting open on his knees, soft warm light.
Large bold left-aligned headline text at the top reads: THE TURN
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Practice feels like
something you want.
Not something you have to."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, peaceful smile, hands open on his knees, warm light streaming in.
Large bold left-aligned headline text at the top reads: 5 WEEKS IN.
YOU'RE CHANGING.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Trust it.
At the bottom in bold text: Follow @stillmeditation for Day 36"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, peaceful smile, hands open on his knees, warm light streaming in.
Large bold left-aligned headline text at the top reads: 5 WEEKS IN.
YOU'RE CHANGING.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Trust it.
At the bottom in bold text: Follow @stillmeditation.app for Day 36"

echo ""
echo "=== Day 35 Complete ==="
