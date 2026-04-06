#!/bin/bash
# Generate Day 8 TikTok slides: "The Body Scan: A Meditation You Can Feel"
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day8"

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

echo "=== Generating Day 8: The Body Scan: A Meditation You Can Feel ==="
echo ""

# SLIDE 1 — HOOK
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting relaxed with arms open wide and a calm almost smug expression — like he is about to share a secret weapon. His posture is open and inviting. His expression says: this one is easy, trust me.

Large bold left-aligned headline text at the top reads: THIS IS THE ONE MEDITATION TECHNIQUE YOU CANNOT OVERTHINK

Below in medium bold text: No breathing to control. No thoughts to stop. Just feel."

# SLIDE 2 — WHAT IT IS
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in meditation with a soft warm golden glow tracing down his body from head to toe — like a slow scan of light moving downward through him. The glow is gentle and visible, showing the path of attention from crown of head down to feet. His eyes are closed and expression is peaceful.

Large bold left-aligned headline text at the top reads: THE BODY SCAN: FEEL YOUR WAY THROUGH YOUR BODY TOP TO BOTTOM

Below in medium bold text: You move your attention slowly down your body, noticing each part as you go."

# SLIDE 3 — STEP 1
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in calm meditation with a warm soft glow focused at the very top of his head — the crown. His eyes are closed and his expression is settled and inward. The glow at the top of his head is the key visual, showing where attention begins.

Large bold left-aligned headline text at the top reads: START AT THE TOP OF YOUR HEAD

Below in medium bold text: Close your eyes. Take a breath. Bring all your attention to the crown of your head. What do you notice there?"

# SLIDE 4 — STEP 2
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in meditation with the warm glow now tracing slowly downward — visible at his neck, shoulders, and chest. The movement is shown as a gradual flow of light descending through his body. His expression is calm and focused inward.

Large bold left-aligned headline text at the top reads: SLOWLY MOVE YOUR ATTENTION DOWNWARD

Below in medium bold text: Head. Neck. Shoulders. Chest. Belly. Take your time. Spend a few seconds on each area."

# SLIDE 5 — THE KEY
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in meditation with a visible tension spot highlighted on one shoulder — shown as a subtle warm red or orange glow indicating tightness. But his expression is completely calm and observant, not trying to fix or change anything. He is simply noticing the tension with curiosity, not judgment.

Large bold left-aligned headline text at the top reads: DO NOT TRY TO CHANGE ANYTHING. JUST NOTICE.

Below in medium bold text: Tight shoulders? Tense jaw? Heavy chest? Just observe it. Awareness alone begins to release it."

# SLIDE 6 — WHY IT WORKS
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting with a look of genuine surprise and discovery on his face — eyebrows slightly raised, eyes wide open, mouth slightly open. He has just noticed tension somewhere in his body he did not know was there. It is a relatable, humanizing moment of unexpected self-discovery. A subtle highlight shows the tension spot he just found.

Large bold left-aligned headline text at the top reads: YOUR BODY HOLDS STRESS YOU DID NOT EVEN KNOW WAS THERE. THIS FINDS IT.

Below in medium bold text: Most people are carrying tension in their jaw, shoulders, or chest right now and have no idea."

# SLIDE 7 — CTA (TikTok)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is lying down in a relaxed, comfortable position — on his back with arms at his sides, eyes closed, completely at rest. His halo ring glows softly above him. The atmosphere is deeply peaceful, warm, and sleepy — like the perfect pre-sleep state. This is the most relaxed we have ever seen the mascot.

IMPORTANT: Only ONE mascot. No mini versions. No App Store badges.

Large bold left-aligned headline text reads: TRY THIS TONIGHT BEFORE YOU GO TO SLEEP

Below in medium bold text: Save this. Follow @stillmeditation for Day 9."

sleep 2

# SLIDE 7 — Instagram version
echo "Generating Slide 7 (Instagram version)..."

PROMPT_IG="Create a bold social media card illustration. ${STYLE} The scene: The muscular purple humanoid mascot is lying down in a relaxed comfortable position — on his back with arms at his sides, eyes closed, completely at rest. His halo ring glows softly above him. The atmosphere is deeply peaceful, warm, and sleepy. IMPORTANT: Only ONE mascot. No mini versions. No App Store badges. Large bold left-aligned headline text reads: TRY THIS TONIGHT BEFORE YOU GO TO SLEEP. Below in medium bold text: Save this. Follow @stillmeditation.app for Day 9."

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
echo "=== Day 8 generation complete! ==="
echo "Check ${OUTPUT_DIR}/ for your slides."
