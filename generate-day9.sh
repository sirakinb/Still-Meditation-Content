#!/bin/bash
# Generate Day 9 TikTok slides: "3 Breaths That Change Your Nervous System"
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day9"

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

echo "=== Generating Day 9: 3 Breaths That Change Your Nervous System ==="
echo ""

# SLIDE 1 — HOOK
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting confidently holding a TV remote control pointed forward — but instead of a TV, behind him is a glowing diagram of the human nervous system like a body outline with glowing neural pathways. The concept is that the breath is the remote control for your nervous system. His expression is confident and knowing.

Large bold left-aligned headline text at the top reads: YOUR NERVOUS SYSTEM HAS A REMOTE CONTROL. IT IS YOUR BREATH.

Below in medium bold text: And once you know how to use it, everything changes."

# SLIDE 2 — THE CONCEPT
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting calmly with three distinct floating breath icons beside him — each one a different style of breath wave (one long exhale, one long inhale, one equal wave). The three icons are clearly different from each other. His expression is calm and anticipatory — like he is about to reveal something useful.

Large bold left-aligned headline text at the top reads: 3 BREATH PATTERNS. 3 DIFFERENT EFFECTS.

Below in medium bold text: One calms you down. One wakes you up. One brings you into balance. Here they are."

# SLIDE 3 — BREATH 1: CALM
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is in a deeply relaxed, melted state — shoulders dropped, expression serene, eyes peacefully closed. A breath wave graphic shows a short inhale followed by a long slow extended exhale. The overall color palette for this slide should feel cool and calming — blues and soft tones.

Large bold left-aligned headline text at the top reads: BREATH 1: EXHALE LONGER THAN INHALE = CALM

Below in medium bold text: Try it: inhale for 4 counts, exhale for 8. Do this when you are stressed, anxious, or overwhelmed."

# SLIDE 4 — BREATH 2: ENERGY
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting upright with alert energized posture — eyes wide open and bright, chest expanded, expression focused and awake. A breath wave graphic shows a long powerful inhale followed by a short exhale. The overall energy of the slide should feel warm and activating — oranges and yellows.

Large bold left-aligned headline text at the top reads: BREATH 2: INHALE LONGER THAN EXHALE = ENERGY

Below in medium bold text: Try it: inhale for 8 counts, exhale for 4. Do this when you are tired, sluggish, or need to focus fast."

# SLIDE 5 — BREATH 3: BALANCE
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a perfectly centered, grounded meditation pose — completely balanced, eyes half open with a calm focused expression. A breath wave graphic shows a perfectly equal inhale and exhale — same length, same shape. The palette should feel neutral and balanced — greens and golds.

Large bold left-aligned headline text at the top reads: BREATH 3: EQUAL INHALE AND EXHALE = BALANCE

Below in medium bold text: Try it: inhale for 5 counts, exhale for 5. Do this when you want clarity, groundedness, or calm focus."

# SLIDE 6 — THE CHEAT SHEET
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting confidently pointing to a bold cheat sheet reference card beside him. The card has three clear rows:
STRESSED? — Exhale longer
TIRED? — Inhale longer
NEED FOCUS? — Make them equal

The mascot looks proud and helpful — like he is handing you a tool you will use forever. The cheat sheet should be large, bold, and easy to read. This is the most saveable slide of the series.

Large bold left-aligned headline text at the top reads: YOUR BREATH CHEAT SHEET

Below the cheat sheet in medium text: Screenshot this."

# SLIDE 7 — CTA with APP PUSH (TikTok)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a calm confident meditation pose with eyes closed and a peaceful satisfied expression. His halo ring glows softly above his head. The atmosphere is warm and inviting. The overall vibe is: you now have the knowledge, here is the tool to put it into practice.

IMPORTANT: Only ONE mascot. No mini versions. No App Store badges or icons.

Large bold left-aligned headline text at the top reads: SAVE THIS. THEN TRY IT IN THE STILL APP.

Below in medium bold text: Still: Meditation is free to download on the App Store. Link in bio."

sleep 2

# SLIDE 7 — Instagram version
echo "Generating Slide 7 (Instagram version)..."

PROMPT_IG="Create a bold social media card illustration. ${STYLE} The scene: The muscular purple humanoid mascot is sitting in a calm confident meditation pose with eyes closed and a peaceful satisfied expression. His halo ring glows softly above his head. The atmosphere is warm and inviting. IMPORTANT: Only ONE mascot. No mini versions. No App Store badges or icons. Large bold left-aligned headline text at the top reads: SAVE THIS. THEN TRY IT IN THE STILL APP. Below in medium bold text: Still: Meditation is free to download on the App Store. Link in bio."

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
echo "=== Day 9 generation complete! ==="
echo "Check ${OUTPUT_DIR}/ for your slides."
