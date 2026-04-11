#!/bin/bash
# Generate Day 11 TikTok slides: "5-Minute Body Scan Before Bed"
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day11"

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

  echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' | base64 -d > "$filename"

  if [ -f "$filename" ] && [ -s "$filename" ]; then
    echo "✓ Slide ${slide_num} saved ($(ls -la "$filename" | awk '{print $5}') bytes)"
  else
    echo "✗ Slide ${slide_num} FAILED"
  fi
}

# Slide 1 — Hook
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The muscular purple humanoid mascot is lying in bed at night, holding up a phone scrolling through it with a slightly guilty/tired expression. The room is dark with soft moonlight. The phone screen glows on his face.
Large bold left-aligned headline text at the top reads: TONIGHT, TRY THIS INSTEAD OF SCROLLING"

# Slide 2 — Context
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The muscular purple humanoid mascot is putting his phone face-down on the nightstand, looking determined and ready for something better. Soft bedroom lighting with moonlight.
Large bold left-aligned headline text at the top reads: A 5-MINUTE BODY SCAN BEFORE BED
Below in medium bold text: It helps you fall asleep faster, release tension you didn't know you were holding, and wake up feeling more rested."

# Slide 3 — Step 1
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The muscular purple humanoid mascot is lying on his back in bed with eyes closed, hands at his sides, in a relaxed body scan position. A soft glowing light surrounds the top of his head, indicating attention focused there.
Large bold left-aligned headline text at the top reads: STEP 1: LIE DOWN AND CLOSE YOUR EYES
Below in medium bold text: Start at the top of your head. Notice any tension, tingling, or warmth. Spend 30 seconds here. Don't try to fix anything — just notice."

# Slide 4 — Step 2
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The muscular purple humanoid mascot lying in bed with eyes closed. A soft glowing zone of light moves from his neck down through his shoulders and arms and hands. The glow indicates body awareness moving downward.
Large bold left-aligned headline text at the top reads: STEP 2: MOVE DOWN SLOWLY
Below in medium bold text: Neck and shoulders (30 sec). Arms and hands (30 sec). Notice where you're holding tightness. Let your attention rest there without forcing relaxation."

# Slide 5 — Step 3
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The muscular purple humanoid mascot lying in bed with eyes closed. The soft glowing zone of awareness is now in his chest and belly area, expanding gently with each breath.
Large bold left-aligned headline text at the top reads: STEP 3: CHEST, BELLY, HIPS
Below in medium bold text: Feel your breathing here. Notice your chest rise and fall. Move to your belly — is it tight or soft? Then hips. 30 seconds each zone. Just observe."

# Slide 6 — Step 4
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The muscular purple humanoid mascot lying in bed with eyes closed. The glowing zone of awareness has moved all the way down to his legs and feet. His entire body has a subtle peaceful glow now.
Large bold left-aligned headline text at the top reads: STEP 4: LEGS AND FEET — THEN LET GO
Below in medium bold text: Finish with legs (30 sec) and feet (30 sec). Then let your awareness expand to your whole body at once. Breathe. You're done."

# Slide 7 — CTA (TikTok)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The muscular purple humanoid mascot is peacefully asleep in bed with a subtle satisfied smile, looking deeply relaxed. Soft moonlight and stars visible through a window. The overall feeling is serenity.
Large bold left-aligned headline text at the top reads: YOUR CHALLENGE TONIGHT
Below in medium bold text: Do this 5-minute body scan before bed. You will fall asleep faster than scrolling. Save this and try it tonight.
At the bottom in bold text: Follow @stillmeditation for Day 12"

# Slide 7 — CTA (Instagram)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The muscular purple humanoid mascot is peacefully asleep in bed with a subtle satisfied smile, looking deeply relaxed. Soft moonlight and stars visible through a window. The overall feeling is serenity.
Large bold left-aligned headline text at the top reads: YOUR CHALLENGE TONIGHT
Below in medium bold text: Do this 5-minute body scan before bed. You will fall asleep faster than scrolling. Save this and try it tonight.
At the bottom in bold text: Follow @stillmeditation.app for Day 12"

echo ""
echo "=== Day 11 Complete ==="
echo "Slides saved to ${OUTPUT_DIR}/"
