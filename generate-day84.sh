#!/bin/bash
# Generate Day 84 slides: "12 weeks: the comprehensive assessment" — CHECK-IN
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day84"

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
The scene: The mascot stands tall and proud, arms relaxed, a warm satisfied half-smile — the look of someone who has done 12 weeks of real work and is ready to honestly assess it. Soft golden light around him.
Large bold left-aligned headline text at the top reads: 12 WEEKS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Here's your
meditation
report card."

# Slide 2 — Physical Gains
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits in meditation pose, eyes softly closed, relaxed body, the picture of physical calm — low heart rate, no tension, easy breath.
Large bold left-aligned ALL-CAPS section header at the top reads: PHYSICAL
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Sleep deeper?
Less tension?
Heart rate lower?"

# Slide 3 — Mental Gains
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright with a focused, clear expression — eyes slightly open, one finger resting near his temple, the look of someone in full command of their attention.
Large bold left-aligned ALL-CAPS section header at the top reads: MENTAL
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Focus sharper?
Reacting slower?
Catching thoughts?"

# Slide 4 — Emotional Gains
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged with hands open on his knees, a warm compassionate expression — settled, equanimous, the look of someone who isn't easily rocked.
Large bold left-aligned ALL-CAPS section header at the top reads: EMOTIONAL
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: More compassion?
More resilient?
Steadier inside?"

# Slide 5 — Spiritual Gains
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation outside or near a window with soft light, a look of quiet spaciousness and presence — eyes gently closed, the sense of someone who feels connected to something larger.
Large bold left-aligned ALL-CAPS section header at the top reads: SPIRITUAL
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: More spacious?
More present?
More connected?"

# Slide 6 — Reflect + Rate
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot tilts his head slightly with a warm, encouraging nod — the look of someone inviting honest reflection without judgment.
Large bold left-aligned ALL-CAPS section header at the top reads: REFLECT
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Rate each area.
Notice where
you've grown most."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands with open arms and a broad warm smile — the posture of genuine celebration for 12 weeks of showing up for oneself. Warm golden light fills the scene.
Large bold left-aligned headline text at the top reads: 12 WEEKS DONE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The growth is real.
The practice is yours.
Keep going.
At the bottom in bold text: Follow @stillmeditation for Day 85"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands with open arms and a broad warm smile — the posture of genuine celebration for 12 weeks of showing up for oneself. Warm golden light fills the scene.
Large bold left-aligned headline text at the top reads: 12 WEEKS DONE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The growth is real.
The practice is yours.
Keep going.
At the bottom in bold text: Follow @stillmeditation.app for Day 85"

echo ""
echo "=== Day 84 Complete ==="
