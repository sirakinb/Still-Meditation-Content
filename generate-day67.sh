#!/bin/bash
# Generate Day 67 slides: "How breathwork boosts your immune system" (SCIENCE)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day67"

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

  size=$(stat -f%z "$filename" 2>/dev/null || stat -c%s "$filename")
  if [ "$size" -lt 10000 ]; then
    echo "✗ Slide ${slide_num} FAILED: output file is only ${size} bytes" >&2
    exit 1
  fi
  echo "✓ Slide ${slide_num} saved (${size} bytes)"
}

# Slide 1 — Hook
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with arms slightly open, confident and energized expression, soft warm glow around his body suggesting vitality and health. Background: bright open setting with subtle warm light.
Large bold left-aligned headline text at the top reads: YOUR BREATH CAN FIGHT INFLAMMATION.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The research is wild.
Scientists proved it.
In 2014."

# Slide 2 — The study setup
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands in a calm science lab setting, looking curious and focused, soft natural light.
Large bold left-aligned headline text at the top reads: THE EXPERIMENT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Radboud University.
2014.
10 days of breathwork training."

# Slide 3 — The test
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands firm and calm, chest open, steady composed expression, soft warm light.
Large bold left-aligned headline text at the top reads: THE TEST
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Participants were injected
with bacterial endotoxin.
Their immune response was measured."

# Slide 4 — The result
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall with a proud, amazed expression, one hand raised slightly, glowing warm energy radiating from his body.
Large bold left-aligned headline text at the top reads: THE RESULT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 200% more
anti-inflammatory cytokines.
Flu symptoms: dramatically reduced."

# Slide 5 — What it means
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in a calm meditation pose, eyes softly closed, peaceful expression, soft natural light around him.
Large bold left-aligned headline text at the top reads: WHAT IT MEANS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Your autonomic nervous system
controls your immune response.
Breathwork trains that system."

# Slide 6 — How to apply it
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits on a cushion, eyes closed, hands resting on knees, calm and steady mid-breath, soft warm light.
Large bold left-aligned headline text at the top reads: YOUR PROTOCOL
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 10 minutes daily.
Deep rhythmic breathing.
Consistency = results."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with chest open, arms slightly wide, strong and healthy expression, warm vibrant light around him.
Large bold left-aligned headline text at the top reads: BREATHE.
HEAL.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Your immune system
is listening.
At the bottom in bold text: Follow @stillmeditation for Day 68"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with chest open, arms slightly wide, strong and healthy expression, warm vibrant light around him.
Large bold left-aligned headline text at the top reads: BREATHE.
HEAL.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Your immune system
is listening.
At the bottom in bold text: Follow @stillmeditation.app for Day 68"

echo ""
echo "=== Day 67 Complete ==="
