#!/bin/bash
# Generate Day 44 slides: "The meditation plateau is real — and it's a good sign" (MOTIVATION)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day44"

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
The scene: The mascot sits cross-legged on a cushion, eyes softly closed, a slightly bored expression but still composed. Soft warm light.
Large bold left-aligned headline text at the top reads: MEDITATION GOT BORING.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Good.
That means it is working."

# Slide 2 — The plateau
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits on a cushion, calm but slightly weary expression, soft natural light.
Large bold left-aligned headline text at the top reads: THE PLATEAU
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Week six.
The excitement fades.
Sessions feel routine."

# Slide 3 — Why it happens
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged, eyes closed, calm and steady, soft warm light.
Large bold left-aligned headline text at the top reads: WHY IT HAPPENS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Your brain adapted.
The novelty is gone.
The work begins."

# Slide 4 — Like driving
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands relaxed, calm thoughtful expression, soft natural light.
Large bold left-aligned headline text at the top reads: LIKE DRIVING
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Boring means
automatic.
Automatic means trained."

# Slide 5 — The trap
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands looking calm but firm, soft natural light.
Large bold left-aligned headline text at the top reads: THE TRAP
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Most people quit here.
They mistake boredom
for failure."

# Slide 6 — The shift
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation, eyes closed, calm steady focused expression, soft natural light.
Large bold left-aligned headline text at the top reads: THE SHIFT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Stop chasing bliss.
Start showing up.
That is the practice."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with calm confident posture, soft warm glow around him.
Large bold left-aligned headline text at the top reads: KEEP GOING.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The boring middle
is where it works.
At the bottom in bold text: Follow @stillmeditation for Day 45"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with calm confident posture, soft warm glow around him.
Large bold left-aligned headline text at the top reads: KEEP GOING.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The boring middle
is where it works.
At the bottom in bold text: Follow @stillmeditation.app for Day 45"

echo ""
echo "=== Day 44 Complete ==="
