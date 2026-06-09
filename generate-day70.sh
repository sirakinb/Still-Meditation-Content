#!/bin/bash
# Generate Day 70 slides: "10 weeks: the deep practice self-assessment" — CHECK-IN
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day70"

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
The scene: The mascot stands with arms relaxed, head slightly tilted, a thoughtful self-reflective expression, soft warm light around him, like someone pausing to honestly take stock.
Large bold left-aligned headline text at the top reads: 10 WEEKS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Let's see what's
actually shifted."

# Slide 2 — Can You Sit?
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits cross-legged in a steady upright meditation posture, eyes softly closed, completely still and relaxed, no fidgeting, the look of someone at home in the silence.
Large bold left-aligned ALL-CAPS section header at the top reads: CAN YOU SIT?
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: 20 minutes.
No clock checks.
Just presence."

# Slide 3 — Real-Time Awareness
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot holds one hand to his chest with a calm, observant expression — like someone noticing a feeling without being swept away by it, a small knowing nod.
Large bold left-aligned ALL-CAPS section header at the top reads: EMOTIONS
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Can you name it
in real time?
Before it owns you?"

# Slide 4 — Breath Awareness
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot walks in a calm everyday setting — perhaps near a window — pausing mid-step with a soft smile, eyes open, hand resting near his chest, catching his own breath in the middle of the day.
Large bold left-aligned ALL-CAPS section header at the top reads: DAILY BREATH
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Do you notice it
without trying?
That's the shift."

# Slide 5 — Loving-Kindness
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged with hands open in his lap, a soft compassionate expression on his face, warm gentle light, the feeling of someone sending quiet warmth to someone difficult.
Large bold left-aligned ALL-CAPS section header at the top reads: LOVING-KINDNESS
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: A difficult person.
Can you hold them
with warmth?"

# Slide 6 — Final Phase
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall with a quiet confident expression, both hands slightly raised palms-up, a forward-facing stance — the look of someone ready for what comes next.
Large bold left-aligned ALL-CAPS section header at the top reads: READY
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: If most answers
are yes — you're set
for the final phase."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with a calm, proud half-smile, soft golden light around him, the posture of someone who has done real work and knows it.
Large bold left-aligned headline text at the top reads: 10 WEEKS IN.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The practice is
no longer something
you do. It is you.
At the bottom in bold text: Follow @stillmeditation for Day 71"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with a calm, proud half-smile, soft golden light around him, the posture of someone who has done real work and knows it.
Large bold left-aligned headline text at the top reads: 10 WEEKS IN.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The practice is
no longer something
you do. It is you.
At the bottom in bold text: Follow @stillmeditation.app for Day 71"

echo ""
echo "=== Day 70 Complete ==="
