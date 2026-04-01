#!/bin/bash
# Generate Day 5 TikTok slides: "5 Lies You've Been Told About Meditation"
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day5"

mkdir -p "$OUTPUT_DIR"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Background: warm zen meditation room with wooden floors, soft natural light, green plants. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation for TikTok. Only ONE instance of the mascot per image — never add miniature versions or icons of the character."

generate_slide() {
  local slide_num=$1
  local prompt=$2
  local filename="${OUTPUT_DIR}/slide${slide_num}.png"

  echo "Generating Slide ${slide_num}..."

  response=$(curl -s -X POST "${ENDPOINT}" \
    -H "x-goog-api-key: ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{
      \"contents\": [{
        \"parts\": [{\"text\": $(echo "$prompt" | jq -Rs .)}]
      }],
      \"generationConfig\": {
        \"responseModalities\": [\"TEXT\", \"IMAGE\"]
      }
    }")

  image_data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' 2>/dev/null)

  if [ -n "$image_data" ] && [ "$image_data" != "null" ]; then
    echo "$image_data" | base64 -d > "$filename"
    echo "  Saved: $filename"
  else
    echo "  ERROR generating slide ${slide_num}"
    echo "$response" | jq '.error' > "${OUTPUT_DIR}/slide${slide_num}_error.json"
  fi

  sleep 2
}

echo "=== Generating Day 5: 5 Lies You've Been Told About Meditation ==="
echo ""

# SLIDE 1 — HOOK
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is standing with arms crossed and one eyebrow raised — confident, challenging, calling the viewer out. His expression is bold and slightly provocative, like he is about to bust some myths wide open. Strong challenger energy.

Large bold left-aligned headline text at the top reads: EVERYTHING YOU BELIEVE ABOUT MEDITATION IS PROBABLY WRONG

Below in medium bold text: 5 lies you need to stop believing."

# SLIDE 2 — LIE #1: SILENCE
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a calm meditation pose outdoors or in a lively environment — there are subtle sound wave icons around him representing city noise, birds, traffic. Despite the noise around him, he looks completely at peace. The contrast between the noise and his calm is the key visual.

Large bold left-aligned headline text at the top reads: LIE #1: YOU NEED SILENCE TO MEDITATE

Below in medium bold text: Truth: Noise is just another thing to notice. The city, the birds, the traffic — it all becomes part of the practice."

# SLIDE 3 — LIE #2: CROSS-LEGGED
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is meditating in a casual, comfortable position — sitting in a chair or on a couch, not in a perfect lotus pose. He looks relaxed and at ease. The vibe is approachable and freeing, not rigid or formal.

Large bold left-aligned headline text at the top reads: LIE #2: YOU HAVE TO SIT CROSS-LEGGED

Below in medium bold text: Truth: Chair, couch, floor, bed. Any comfortable position is the right position."

# SLIDE 4 — LIE #3: 30 MINUTES
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a short meditation pose with a clock or timer visible showing only 3 minutes. He looks satisfied and accomplished — like he just completed a full session in 3 minutes. The vibe is liberating and empowering.

Large bold left-aligned headline text at the top reads: LIE #3: YOU NEED 30 MINUTES

Below in medium bold text: Truth: 3 minutes is a complete session. Start there. Build from there."

# SLIDE 5 — LIE #4: YOU CAN BE BAD AT IT
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot has a big bold X or prohibition symbol nearby — but he looks calm and unbothered. He is sitting in meditation with thoughts visibly drifting away, but his expression is peaceful not frustrated. The message is that struggling IS succeeding.

Large bold left-aligned headline text at the top reads: LIE #4: YOU CAN BE BAD AT MEDITATION

Below in medium bold text: Truth: Noticing your mind wandered IS the practice. That moment of awareness is a rep. You literally cannot fail."

# SLIDE 6 — LIE #5: FIDGETING
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in meditation but slightly imperfect — maybe one hand is adjusting position, or he is scratching his nose, looking a little fidgety but still clearly meditating and calm. His expression is relaxed and unworried. The vibe is relatable and humanizing.

Large bold left-aligned headline text at the top reads: LIE #5: FIDGETING MEANS YOU ARE DOING IT WRONG

Below in medium bold text: Truth: Your body is settling. It is part of the process. Adjust, scratch, shift — then return to your breath."

# SLIDE 7 — CTA (TikTok)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting relaxed with a warm knowing smile — like he is in on the secret and inviting you in too. His halo ring glows softly above his head. He looks directly at the viewer in a friendly, engaging way. The vibe is warm and inviting, encouraging comment engagement.

IMPORTANT: Only ONE mascot. No mini versions. No App Store badges.

Large bold left-aligned headline text at the top reads: WHICH LIE WERE YOU BELIEVING?

Below in medium bold text: Comment below. Follow @stillmeditation for Day 6: how to actually breathe from your belly."

sleep 2

# SLIDE 7 — Instagram version
echo "Generating Slide 7 (Instagram version)..."

PROMPT_IG="Create a bold social media card illustration. ${STYLE} The scene: The muscular purple humanoid mascot is sitting relaxed with a warm knowing smile — like he is in on the secret and inviting you in too. His halo ring glows softly above his head. He looks directly at the viewer in a friendly, engaging way. The vibe is warm and inviting, encouraging comment engagement. IMPORTANT: Only ONE mascot. No mini versions. No App Store badges. Large bold left-aligned headline text at the top reads: WHICH LIE WERE YOU BELIEVING? Below in medium bold text: Comment below. Follow @stillmeditation.app for Day 6: how to actually breathe from your belly."

response=$(curl -s -X POST "${ENDPOINT}" \
  -H "x-goog-api-key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"contents\": [{
      \"parts\": [{\"text\": $(echo "$PROMPT_IG" | jq -Rs .)}]
    }],
    \"generationConfig\": {
      \"responseModalities\": [\"TEXT\", \"IMAGE\"]
    }
  }")

image_data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' 2>/dev/null)

if [ -n "$image_data" ] && [ "$image_data" != "null" ]; then
  echo "$image_data" | base64 -d > "${OUTPUT_DIR}/slide7_instagram.png"
  echo "  Saved: ${OUTPUT_DIR}/slide7_instagram.png"
else
  echo "  ERROR generating Instagram slide 7"
fi

echo ""
echo "=== Day 5 generation complete! ==="
echo "Check ${OUTPUT_DIR}/ for your slides."
