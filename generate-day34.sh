#!/bin/bash
# Generate Day 34 slides: "Your first 10-minute practice (with a twist)" (TUTORIAL)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day34"

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
The scene: The mascot sits cross-legged in calm meditation, eyes softly closed, peaceful smile, warm morning light around him.
Large bold left-aligned headline text at the top reads: YOUR FIRST
10 MINUTES.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: With a twist."

# Slide 2 — The twist
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands with a calm confident smile, one hand raised showing three fingers.
Large bold left-aligned headline text at the top reads: THE TWIST
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Three trainings.
One sit."

# Slide 3 — Minutes 1 to 3
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in calm meditation, eyes softly closed, hand resting near his chest, focused on breath.
Large bold left-aligned headline text at the top reads: MIN 1 to 3
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Breath awareness.
Just feel each inhale.
Each exhale."

# Slide 4 — Minutes 4 to 6
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in calm meditation, eyes softly closed, soft glow tracing down his body from head to feet.
Large bold left-aligned headline text at the top reads: MIN 4 to 6
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Body scan.
Move attention slowly.
Head to feet."

# Slide 5 — Minutes 7 to 9
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in calm meditation, both hands resting over his heart, soft warm smile, gentle pink glow around him.
Large bold left-aligned headline text at the top reads: MIN 7 to 9
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Kindness phrases.
May I be safe.
May I be at peace."

# Slide 6 — Minute 10
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in serene meditation, hands open and relaxed on his knees, peaceful balanced expression, soft warm light.
Large bold left-aligned headline text at the top reads: MIN 10
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Open sitting.
No technique.
Just rest."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, soft peaceful smile, hands resting open on his knees, warm light streaming in.
Large bold left-aligned headline text at the top reads: 10 MINUTES.
3 TRAININGS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Try it once today.
At the bottom in bold text: Follow @stillmeditation for Day 35"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in serene meditation on a cushion in a sunlit room, soft peaceful smile, hands resting open on his knees, warm light streaming in.
Large bold left-aligned headline text at the top reads: 10 MINUTES.
3 TRAININGS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Try it once today.
At the bottom in bold text: Follow @stillmeditation.app for Day 35"

echo ""
echo "=== Day 34 Complete ==="
