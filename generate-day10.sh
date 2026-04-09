#!/bin/bash
# Generate Day 10 TikTok slides: "The Vagus Nerve: Your Body's Chill Button"
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day10"

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

echo "=== Generating Day 10: The Vagus Nerve: Your Body's Chill Button ==="
echo ""

# SLIDE 1 — HOOK
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in meditation with a glowing nerve pathway visible running from his brain down through his chest and into his gut — like a luminous golden thread lighting up inside him. His expression shows calm wonder. The nerve pathway is the star of the visual — mysterious and intriguing.

Large bold left-aligned headline text at the top reads: THERE IS A NERVE THAT CONTROLS HOW STRESSED YOU FEEL

Below in medium bold text: And you can activate it on demand with your breath."

# SLIDE 2 — WHAT IT IS
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting beside a clear anatomy-style diagram showing the vagus nerve pathway — a glowing line running from the brain stem, down through the neck, branching through the heart and lungs, continuing down to the gut. The diagram is simple, bold, and easy to read. Key organs are labeled: BRAIN, HEART, LUNGS, GUT. The mascot points to it like a professor.

Large bold left-aligned headline text at the top reads: MEET THE VAGUS NERVE

Below in medium bold text: It runs from your brain to your gut. It is the longest nerve in your body. And it is your built-in calm switch."

# SLIDE 3 — HOW IT WORKS
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a slow deliberate breathing pose — a visible slow breath wave flowing in and out. The vagus nerve pathway inside him is glowing brightly, being activated by the slow breathing. A subtle heart rate indicator shows the heart rate dropping. The visual connection between slow breath and nerve activation is clear.

Large bold left-aligned headline text at the top reads: SLOW BREATHING DIRECTLY STIMULATES IT

Below in medium bold text: 6 breaths per minute activates the vagus nerve and drops your heart rate, blood pressure, and cortisol — in real time."

# SLIDE 4 — THE PROOF
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is visibly relaxing in real time — shoulders dropping, face softening, tension leaving his body. The vagus nerve pathway inside him is lit up brightly. A before/after contrast is implied: tense going in, calm coming out. His expression shows genuine relief and calm.

Large bold left-aligned headline text at the top reads: THIS IS WHY BREATHING EXERCISES WORK INSTANTLY

Below in medium bold text: It is not placebo. It is not in your head. It is actual nerve activation happening in your body right now."

# SLIDE 5 — THE NUMBER
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a measured, precise breathing pose. A large bold number 6 is displayed prominently — representing 6 breaths per minute. A simple breath cycle timer shows 5 seconds in and 5 seconds out. The mascot looks focused and precise, like he is timing himself perfectly.

Large bold left-aligned headline text at the top reads: 6 BREATHS PER MINUTE. THAT IS THE MAGIC NUMBER.

Below in medium bold text: 5 seconds in. 5 seconds out. This specific rhythm maximizes your vagal tone and stress resilience."

# SLIDE 6 — THE PAYOFF
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a powerful, calm meditation pose — strong, grounded, and completely at peace. The vagus nerve inside him glows steadily. His expression is confident and empowered — not soft calm, but strong calm. The vibe is: this is biology, this is real, and you are in control of it.

Large bold left-aligned headline text at the top reads: EVERY TIME YOU BREATHE SLOWLY YOU ARE PHYSICALLY REWIRING YOUR STRESS RESPONSE

Below in medium bold text: Not metaphorically. Literally. Your nervous system changes with practice."

# SLIDE 7 — CTA (TikTok)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}

The scene: The muscular purple humanoid mascot is sitting in a calm confident meditation pose with eyes closed and a knowing peaceful smile. His halo ring glows softly above his head. The vagus nerve pathway glows faintly inside him — a subtle callback to the series. The atmosphere is warm and empowering.

IMPORTANT: Only ONE mascot. No mini versions. No App Store badges.

Large bold left-aligned headline text at the top reads: YOUR BODY ALREADY KNOWS HOW TO CALM DOWN. YOUR BREATH IS THE TRIGGER.

Below in medium bold text: Follow @stillmeditation for Day 11."

sleep 2

# SLIDE 7 — Instagram version
echo "Generating Slide 7 (Instagram version)..."

PROMPT_IG="Create a bold social media card illustration. ${STYLE} The scene: The muscular purple humanoid mascot is sitting in a calm confident meditation pose with eyes closed and a knowing peaceful smile. His halo ring glows softly above his head. The vagus nerve pathway glows faintly inside him. The atmosphere is warm and empowering. IMPORTANT: Only ONE mascot. No mini versions. No App Store badges. Large bold left-aligned headline text at the top reads: YOUR BODY ALREADY KNOWS HOW TO CALM DOWN. YOUR BREATH IS THE TRIGGER. Below in medium bold text: Follow @stillmeditation.app for Day 11."

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
echo "=== Day 10 generation complete! ==="
echo "Check ${OUTPUT_DIR}/ for your slides."
