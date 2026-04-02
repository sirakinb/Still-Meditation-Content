#!/bin/bash
# Generate Day 6 TikTok slides: "How to Actually Breathe From Your Belly"
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day6"

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

echo "=== Generating Day 6: How to Actually Breathe From Your Belly ==="
echo ""

# SLIDE 1 — HOOK
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is standing upright, looking directly at the viewer with a calm but slightly stunned expression — like he is about to reveal something the viewer has overlooked their entire life. His posture is open and engaging.

Large bold left-aligned headline text at the top reads: YOU HAVE BEEN BREATHING WRONG YOUR WHOLE LIFE

Below in medium bold text: And it is keeping you more stressed than you need to be."

# SLIDE 2 — THE TEST
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting upright with one hand placed flat on his chest and one hand placed flat on his belly. He is looking down at his hands with a focused, curious expression — like he is checking something important. The two hand positions are clearly visible and distinct.

Large bold left-aligned headline text at the top reads: HERE IS HOW TO FIND OUT

Below in medium bold text: Place one hand on your chest. One hand on your belly. Now take a normal breath. Which hand moves?"

# SLIDE 3 — THE PROBLEM
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is shown with a visible diagram beside him — two simple side-profile breath illustrations: one showing a shallow chest breath (small, high, tight) labeled CHEST and one showing a deep belly breath (full, low, expansive) labeled BELLY. The chest breathing figure looks slightly tense. The belly breathing figure looks calm. The contrast is clear.

Large bold left-aligned headline text at the top reads: CHEST BREATHING KEEPS YOU IN STRESS MODE

Below in medium bold text: It activates your fight-or-flight response. Belly breathing activates your calm."

# SLIDE 4 — SETUP
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a comfortable upright position with one hand on his chest and one hand on his belly — demonstrating the hand placement clearly and instructionally. His expression is calm and focused. The hands are clearly labeled or visually distinct — chest hand stays still, belly hand will move.

Large bold left-aligned headline text at the top reads: PUT ONE HAND ON YOUR CHEST. ONE ON YOUR BELLY.

Below in medium bold text: Only the belly hand should move. The chest hand stays still. That is the goal."

# SLIDE 5 — INHALE
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting with hands on chest and belly, clearly inhaling — his belly is visibly expanding outward, pushing the belly hand forward. A bold number 5 with an upward arrow is displayed nearby indicating the 5-count inhale. A breath line flows in through his nose. The belly expansion is the key visual.

Large bold left-aligned headline text at the top reads: INHALE THROUGH YOUR NOSE — 5 COUNTS. BELLY PUSHES OUT.

Below in medium bold text: 1... 2... 3... 4... 5. Let your belly expand like a balloon filling with air."

# SLIDE 6 — EXHALE
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting with hands on chest and belly, now exhaling — his belly is visibly contracting inward, the belly hand falling back. A bold number 5 with a downward arrow is displayed nearby indicating the 5-count exhale. A breath line flows out through his nose. His expression shows visible calm and release.

Large bold left-aligned headline text at the top reads: EXHALE THROUGH YOUR NOSE — 5 COUNTS. BELLY FALLS BACK.

Below in medium bold text: Do this 5 times right now. Notice the difference."

# SLIDE 7 — CTA (TikTok)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a calm, confident meditation pose with eyes closed and a peaceful, satisfied expression. His halo ring glows softly above his head. The overall atmosphere is warm, empowering, and calm — like someone who just unlocked a skill they will use forever.

IMPORTANT: Only ONE mascot. No mini versions. No App Store badges.

Large bold left-aligned headline text at the top reads: THIS IS THE MOST UNDERRATED SKILL YOU WILL EVER LEARN

Below in medium bold text: Save this. Follow @stillmeditation for Day 7."

sleep 2

# SLIDE 7 — Instagram version
echo "Generating Slide 7 (Instagram version)..."

PROMPT_IG="Create a bold social media card illustration. ${STYLE} The scene: The muscular purple humanoid mascot is sitting in a calm confident meditation pose with eyes closed and a peaceful satisfied expression. His halo ring glows softly above his head. The atmosphere is warm, empowering, and calm. IMPORTANT: Only ONE mascot. No mini versions. No App Store badges. Large bold left-aligned headline text at the top reads: THIS IS THE MOST UNDERRATED SKILL YOU WILL EVER LEARN. Below in medium bold text: Save this. Follow @stillmeditation.app for Day 7."

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
echo "=== Day 6 generation complete! ==="
echo "Check ${OUTPUT_DIR}/ for your slides."
