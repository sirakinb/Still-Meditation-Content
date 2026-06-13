#!/bin/bash
# Generate Day 74 slides: "Building your breathwork toolkit: which technique for which need" (QUICK TIP)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day74"

mkdir -p "$OUTPUT_DIR"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm zen meditation room with wooden floors, soft natural light, green plants — UNLESS the scene calls for another setting. DO NOT include any text branding or logo anywhere. DO NOT draw any internal frames, borders, mini-cards, or picture-in-picture elements — the mascot is part of the same single scene as the text. Light warm background with rounded corners on the OUTER card only. Text should be bold, large, left-aligned, and highly readable for mobile viewing. Spell every word correctly. 4:5 portrait orientation. Only ONE instance of the mascot per image."

generate_slide() {
  local slide_num=$1
  local prompt=$2
  local filename="${OUTPUT_DIR}/slide${slide_num}.png"

  echo "Generating Slide ${slide_num}..."
  response=$(curl -s -X POST "${ENDPOINT}" \
    -H "x-goog-api-key: ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{\"contents\":[{\"parts\":[{\"text\": $(echo "$prompt" | jq -Rs .)}]}],\"generationConfig\":{\"responseModalities\":[\"TEXT\",\"IMAGE\"]}}")

  # Surface API errors loudly instead of silently writing 0-byte PNGs
  err=$(echo "$response" | jq -r '.error.message // empty')
  if [ -n "$err" ]; then
    echo "✗ Slide ${slide_num} FAILED: $err" >&2
    echo "Aborting — fix the API issue before retrying." >&2
    exit 1
  fi

  data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data')
  if [ -z "$data" ] || [ "$data" = "null" ]; then
    echo "✗ Slide ${slide_num} FAILED: no image data in response" >&2
    echo "Full response:" >&2
    echo "$response" | head -c 800 >&2
    echo "" >&2
    exit 1
  fi

  echo "$data" | base64 -d > "$filename"

  # Sanity-check file size (real PNGs are >100KB; small size means silent failure)
  size=$(stat -f%z "$filename" 2>/dev/null || stat -c%s "$filename")
  if [ "$size" -lt 10000 ]; then
    echo "✗ Slide ${slide_num} FAILED: output file is only ${size} bytes" >&2
    exit 1
  fi
  echo "✓ Slide ${slide_num} saved (${size} bytes)"
}

# Slide 1 — Hook
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands confidently with arms slightly out, surrounded by seven glowing breath-pattern symbols floating around him at chest height — waves, squares, spirals. Warm energetic atmosphere. Symbols stay in the lower half, away from the headline text.
Large bold left-aligned headline text at the top reads: YOUR COMPLETE BREATHWORK CHEAT SHEET
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Save this.
One technique for every state.
Seven tools. Zero guesswork."

# Slide 2 — Intro
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands calm and composed, one hand resting on his chest, the other open at his side. Zen meditation room background.
Large bold left-aligned ALL-CAPS section header at the top reads: 7 STATES. 7 TOOLS.
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Most people use one breath
for everything.
These seven techniques are
each built for a specific state."

# Slide 3 — Stress + Sleep: 4-7-8 and Coherent
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits peacefully with eyes gently closed, moonlit soft glow around him, deeply relaxed posture, calm expression.
Large bold left-aligned ALL-CAPS section header at the top reads: FOR STRESS + SLEEP
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: 4-7-8 breathing.
Inhale 4. Hold 7. Exhale 8.
Activates the parasympathetic.
Also: Coherent — inhale 5. Exhale 5.
Repeat for 5 minutes."

# Slide 4 — Focus: Box breathing
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands upright, sharp and focused, shoulders squared, steady calm gaze, warrior energy.
Large bold left-aligned ALL-CAPS section header at the top reads: FOR FOCUS
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Box breathing.
4 in. 4 hold. 4 out. 4 hold.
Repeat 4 rounds.
Used by Navy SEALs."

# Slide 5 — Energy: Kapalabhati + Wim Hof
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands energized and upright, forward-leaning confident posture, light radiating from his chest, wide awake expression.
Large bold left-aligned ALL-CAPS section header at the top reads: FOR ENERGY
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Kapalabhati: rapid fire exhales.
30 pumps then full exhale hold.
Wim Hof: 30 power inhales.
Full exhale then hold."

# Slide 6 — Emotions, Balance, Pre-meditation
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged, one hand raised to cover his right nostril in the alternate nostril breathing position, balanced serene expression, soft ambient glow.
Large bold left-aligned ALL-CAPS section header at the top reads: EMOTIONS + BALANCE + PREP
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Emotions: 2:1 exhale ratio.
Inhale 4. Exhale 8.
Balance: alternate nostril.
Pre-meditation: cyclic sighing.
Two deep inhales. Long exhale."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, warm soft light around him in a zen meditation room.
Large bold left-aligned headline text at the top reads: SAVE THIS. USE IT TONIGHT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You now have seven tools.
Match the technique to the moment.
Screenshot this slide.
At the bottom in bold text: Follow @stillmeditation for Day 75"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, warm soft light around him in a zen meditation room.
Large bold left-aligned headline text at the top reads: SAVE THIS. USE IT TONIGHT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You now have seven tools.
Match the technique to the moment.
Screenshot this slide.
At the bottom in bold text: Follow @stillmeditation.app for Day 75"

echo ""
echo "=== Day 74 Complete ==="
