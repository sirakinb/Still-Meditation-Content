#!/bin/bash
# Generate Day 4 TikTok slides: "The 1-Minute Breathing Challenge"
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day4"

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

echo "=== Generating Day 4: The 1-Minute Breathing Challenge ==="
echo ""

# SLIDE 1 — HOOK
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is looking directly at the viewer with an energetic, challenging expression — eyebrows raised, slight smirk, arms crossed confidently. Above him is a large bold countdown timer showing 1:00. The energy is playful and daring, like he is issuing a challenge to the viewer.

Large bold left-aligned headline text at the top reads: YOU HAVE 60 SECONDS. LET'S USE THEM.

Below in medium bold text: This is the only breathing exercise you need to start."

# SLIDE 2 — SET THE TIMER
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting upright with good posture, holding up a phone showing a timer set to 1:00. His expression is ready and focused. The overall vibe is simple and action-oriented — just do it right now.

Large bold left-aligned headline text at the top reads: STEP 1: SET A TIMER FOR 60 SECONDS

Below in medium bold text: Right now. Do not skip this."

# SLIDE 3 — INHALE
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a relaxed upright posture with eyes gently closed. He is clearly inhaling — chest and belly expanding slightly, a visible calm breath line flowing in through his nose. A large bold number 4 appears near him with an upward arrow, representing the 4-count inhale. The atmosphere is calm and instructional.

Large bold left-aligned headline text at the top reads: BREATHE IN THROUGH YOUR NOSE — 4 COUNTS

Below in medium bold text: 1... 2... 3... 4. Slow and steady. Fill your belly first."

# SLIDE 4 — EXHALE
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting relaxed with eyes closed, now exhaling — shoulders slightly dropping, a visible breath line flowing gently out through his nose. A large bold number 4 appears with a downward arrow, representing the 4-count exhale. His expression shows visible release and calm.

Large bold left-aligned headline text at the top reads: BREATHE OUT THROUGH YOUR NOSE — 4 COUNTS

Below in medium bold text: Let it all go. Do not rush the exhale."

# SLIDE 5 — REPEAT
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is in a peaceful meditation pose with a calm, settled expression. Around him are soft circular breath cycle icons — showing the inhale and exhale loop repeating. A subtle 60-second timer counts down in the background. The vibe is rhythmic, steady, and calming.

Large bold left-aligned headline text at the top reads: REPEAT UNTIL THE TIMER GOES OFF

Below in medium bold text: That is the whole challenge. Just breathe."

# SLIDE 6 — THE PAYOFF
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting with eyes open now, looking calm, grounded, and slightly surprised in a good way — like he genuinely feels better. His shoulders are relaxed. A soft warm glow surrounds him. The before/after contrast is implied — stressed going in, calm coming out.

Large bold left-aligned headline text at the top reads: NOTICE HOW YOU FEEL.

Below in medium bold text: That shift you just felt? That is your nervous system calming down. In 60 seconds."

# SLIDE 7 — CTA (TikTok)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is in a relaxed meditation pose, eyes closed, with a peaceful satisfied expression. The halo ring glows softly above his head. The atmosphere is warm and inviting. A simple breath cycle icon is visible nearby.

IMPORTANT: Only ONE mascot. No mini versions. No App Store badges.

Large bold left-aligned headline text at the top reads: SAVE THIS FOR WHEN YOU NEED TO CALM DOWN FAST.

Below in medium bold text: Follow @stillmeditation for Day 5: 5 lies about meditation debunked."

sleep 2

# SLIDE 7 — Instagram version
echo "Generating Slide 7 (Instagram version)..."

PROMPT_IG="Create a bold social media card illustration. ${STYLE} The scene: The muscular purple humanoid mascot is in a relaxed meditation pose, eyes closed, with a peaceful satisfied expression. The halo ring glows softly above his head. The atmosphere is warm and inviting. A simple breath cycle icon is visible nearby. IMPORTANT: Only ONE mascot. No mini versions. No App Store badges. Large bold left-aligned headline text at the top reads: SAVE THIS FOR WHEN YOU NEED TO CALM DOWN FAST. Below in medium bold text: Follow @stillmeditation.app for Day 5: 5 lies about meditation debunked."

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
echo "=== Day 4 generation complete! ==="
echo "Check ${OUTPUT_DIR}/ for your slides."
