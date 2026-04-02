#!/bin/bash
# Generate Day 7 TikTok slides: "Why Your Mind Won't Shut Up (And Why That's Good)"
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day7"

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

echo "=== Generating Day 7: Why Your Mind Won't Shut Up (And Why That's Good) ==="
echo ""

# SLIDE 1 — HOOK
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in meditation with a swirling busy cloud of thought bubbles above his head — but his expression is completely calm and unbothered. He is not frustrated by the thoughts. The contrast between the chaotic thought cloud and his peaceful face is the key visual.

Large bold left-aligned headline text at the top reads: YOUR BRAIN IS NOT BROKEN. IT IS DOING ITS JOB.

Below in medium bold text: The busiest minds make the best meditators."

# SLIDE 2 — THE STAT
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is surrounded by dozens of floating thought bubbles of all sizes — work thoughts, random thoughts, worries, ideas, memories. He sits calmly in the center of all of it, looking almost amused. The thought bubbles fill the card creating a visually striking and relatable image. A large bold number 6,000+ is prominently displayed.

Large bold left-aligned headline text at the top reads: THE AVERAGE PERSON HAS 6,000+ THOUGHTS PER DAY

Below in medium bold text: Every single one of them. All day. Every day. That is just a brain being a brain."

# SLIDE 3 — THE REFRAME
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting with a calm relaxed shrug — shoulders slightly raised, palms open, gentle smile. His expression says 'that's just how it is' — totally unbothered and at peace. The vibe is freeing and reassuring.

Large bold left-aligned headline text at the top reads: THAT IS NOT A PROBLEM. THAT IS JUST A BRAIN BEING A BRAIN.

Below in medium bold text: Meditation is not about stopping thoughts. It never was. It is about what you do when you notice them."

# SLIDE 4 — THE INSIGHT
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in meditation with one thought bubble visibly drifting away to the side. He is watching it float away with calm observant eyes — not chasing it, not fighting it. Just noticing it. The moment of noticing is shown clearly through his calm, aware expression.

Large bold left-aligned headline text at the top reads: NOTICING A THOUGHT IS AWARENESS. THAT IS MEDITATION.

Below in medium bold text: The second you realize your mind wandered — that moment of noticing — that is the whole practice."

# SLIDE 5 — THE GYM ANALOGY
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in meditation doing a subtle flex with one arm — a glowing brain icon floats near his flexed bicep, combining mental and physical strength. His expression is confident and empowered. This is a direct callback to the gym/reps analogy from earlier in the series.

Large bold left-aligned headline text at the top reads: EVERY TIME YOU NOTICE AND COME BACK — THAT IS ONE MENTAL PUSH-UP

Below in medium bold text: The wander. The notice. The return. That is one rep. You are building a muscle."

# SLIDE 6 — THE ENCOURAGEMENT
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is in meditation with thoughts visibly flying around him — but he looks strong, grounded, and completely unbothered. Like a rock in a storm. His posture is solid and powerful. The thoughts around him look chaotic but he is immovable and calm.

Large bold left-aligned headline text at the top reads: A BUSY MIND DOES NOT MEAN A BAD MEDITATION. IT MEANS MORE REPS.

Below in medium bold text: The more your mind wanders, the more practice you get. A chaotic mind is just a bigger workout."

# SLIDE 7 — CTA (TikTok)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a warm peaceful meditation pose with eyes closed and a gentle knowing smile. His halo ring glows softly above his head. The atmosphere is warm, calm, and reassuring — like someone who has your back.

IMPORTANT: Only ONE mascot. No mini versions. No App Store badges.

Large bold left-aligned headline text at the top reads: SAVE THIS FOR THE NEXT TIME YOU THINK YOU ARE BAD AT MEDITATING.

Below in medium bold text: You are not bad at it. You are just getting more reps. Follow @stillmeditation for Day 8."

sleep 2

# SLIDE 7 — Instagram version
echo "Generating Slide 7 (Instagram version)..."

PROMPT_IG="Create a bold social media card illustration. ${STYLE} The scene: The muscular purple humanoid mascot is sitting in a warm peaceful meditation pose with eyes closed and a gentle knowing smile. His halo ring glows softly above his head. The atmosphere is warm, calm, and reassuring. IMPORTANT: Only ONE mascot. No mini versions. No App Store badges. Large bold left-aligned headline text at the top reads: SAVE THIS FOR THE NEXT TIME YOU THINK YOU ARE BAD AT MEDITATING. Below in medium bold text: You are not bad at it. You are just getting more reps. Follow @stillmeditation.app for Day 8."

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
echo "=== Day 7 generation complete! ==="
echo "Check ${OUTPUT_DIR}/ for your slides."
