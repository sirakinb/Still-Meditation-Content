#!/bin/bash
# Generate Day 2 TikTok slides: "Your First 3-Minute Meditation"

API_KEY="AIzaSyDpIU_FX8kCO8cOVlu9mf18FSG48-6NirI"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day2"

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
    echo "$response" > "${OUTPUT_DIR}/slide${slide_num}_error.json"
  fi

  sleep 2
}

echo "=== Generating Day 2: Your First 3-Minute Meditation ==="
echo ""

# SLIDE 1 — THE HOOK
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting cross-legged on a dark cushion, holding up 3 fingers on one hand with an inviting friendly expression and slightly open eyes. He looks welcoming and approachable.

The large bold headline text at the top left-aligned reads: YOUR FIRST MEDITATION IN 3 MINUTES

Below in slightly smaller bold text: (NO EXPERIENCE NEEDED)

The text should be heavy black bold font, very large and impactful for mobile."

# SLIDE 2 — THE SETUP
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting casually and relaxed on a comfortable couch or chair — NOT in a perfect meditation pose. He looks casual and approachable, maybe leaning back slightly. This shows meditation doesn't require a perfect setup.

The large bold headline text at the top left-aligned reads: FIND A SEAT. ANY SEAT.

Below in medium bold text left-aligned: A chair, your bed, the floor — it does not matter. Just sit comfortably."

# SLIDE 3 — STEP 1
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a relaxed meditation pose with eyes gently closed. A visible breath line flows in through his nose — a soft curved line showing inhalation. The atmosphere is calm and peaceful.

The large bold headline text at the top left-aligned reads: CLOSE YOUR EYES. TAKE ONE DEEP BREATH.

Below in medium bold text left-aligned: In through your nose. Out through your mouth. That is it."

# SLIDE 4 — STEP 2
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting peacefully in meditation with eyes closed. There is a subtle gentle air flow illustration around his nose and chest area — soft flowing lines showing natural breathing. The atmosphere is very calm and serene.

The large bold headline text at the top left-aligned reads: NOW JUST NOTICE YOUR BREATHING

Below in medium bold text left-aligned: Do not change it. Do not control it. Just feel the air going in and out."

# SLIDE 5 — STEP 3
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in meditation. A single thought bubble is gently drifting away from his head to the side. His expression is peaceful and non-judgmental — slight gentle smile. He is not frustrated or bothered by the wandering thought.

The large bold headline text at the top left-aligned reads: WHEN YOUR MIND WANDERS — AND IT WILL — JUST COME BACK

Below in medium bold text left-aligned: No judgment. No frustration. Just gently return to your breath."

# SLIDE 6 — THE PAYOFF
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting cross-legged in a meditation pose but doing a subtle flex with one arm — a callback to the bicep curl analogy. He has a confident knowing smile. A faint glowing brain icon floats near his flexed arm. This combines meditation calm with fitness strength.

The large bold headline text at the top left-aligned reads: YOU JUST DID YOUR FIRST REP

Below in medium bold text left-aligned: Every time you come back to your breath — that is one rep. You are already building the muscle."

# SLIDE 7 — CTA (TikTok version)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is in a perfect peaceful meditation pose with eyes closed. The signature subtle glowing halo ring floats above his head. The atmosphere is warm golden light, peaceful and inviting. A subtle clock or timer showing 3:00 is somewhere in the background.

IMPORTANT: Only ONE mascot. No mini versions. No App Store badges. No extra icons.

The large bold headline text at the top left-aligned reads: 3 MINUTES. THAT IS ALL IT TAKES.

Below in medium bold text left-aligned: Save this for your first session.

Below that: Follow @stillmeditation for Day 3"

sleep 2

# SLIDE 7 Instagram version
echo "Generating Slide 7 (Instagram version)..."

response=$(curl -s -X POST "${ENDPOINT}" \
  -H "x-goog-api-key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"contents\": [{
      \"parts\": [{\"text\": $(echo "Create a bold social media card illustration. ${STYLE} The scene: The muscular purple humanoid mascot is in a perfect peaceful meditation pose with eyes closed. The signature subtle glowing halo ring floats above his head. The atmosphere is warm golden light, peaceful and inviting. A subtle clock or timer showing 3:00 is somewhere in the background. IMPORTANT: Only ONE mascot. No mini versions. No App Store badges. No extra icons. The large bold headline text at the top left-aligned reads: 3 MINUTES. THAT IS ALL IT TAKES. Below in medium bold text left-aligned: Save this for your first session. Below that: Follow @stillmeditation.app for Day 3" | jq -Rs .)}]
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
echo "=== Day 2 generation complete! ==="
echo "Check ${OUTPUT_DIR}/ for your slides."
