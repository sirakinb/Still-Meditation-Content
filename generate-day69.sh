#!/bin/bash
# Generate Day 69 slides: "The two types of meditators at Day 70" — MOTIVATION
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day69"

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
The scene: The mascot stands at a crossroads, one hand on his chin, expression curious and thoughtful, weighing a choice, soft warm light.
Large bold left-aligned headline text at the top reads: WHICH ONE ARE YOU?
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Two kinds of meditators
make it to Day 70.
Only one stays."

# Slide 2 — Type 1
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits in meditation pose with wide excited eyes, hands open, looking around eagerly, slightly fidgety posture.
Large bold left-aligned headline text at the top reads: TYPE 1
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Chases peak states.
Needs the tingles.
Waits for the wow."

# Slide 3 — Type 2
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in calm steady meditation pose, eyes softly closed, expression relaxed and grounded, not dramatic, just present.
Large bold left-aligned headline text at the top reads: TYPE 2
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Shows up daily.
Doesn't need to feel it
to do it."

# Slide 4 — What happens to Type 1
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits arms crossed, looking disappointed and bored, slumped posture, unimpressed expression.
Large bold left-aligned headline text at the top reads: TYPE 1 QUITS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: When ordinary sits arrive,
they check out.
No fireworks, no point."

# Slide 5 — What Type 2 discovers
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in quiet calm meditation, a small soft smile, completely at ease in an ordinary moment, warm gentle light around him.
Large bold left-aligned headline text at the top reads: TYPE 2 FINDS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Ordinary awareness
IS the peak.
Nothing to wait for."

# Slide 6 — The truth
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall and grounded, confident open posture, steady calm expression, warm soft glow around him.
Large bold left-aligned headline text at the top reads: THE TRUTH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You don't find presence.
You practice it.
Every boring session counts."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands strong and calm with a warm confident smile, relaxed open posture, steady peaceful expression, soft warm light behind him.
Large bold left-aligned headline text at the top reads: BE TYPE 2.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Show up tomorrow.
Ordinary is enough.
At the bottom in bold text: Follow @stillmeditation for Day 70
Spell every word correctly. The username is @stillmeditation — one word, do NOT duplicate the word still."

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands strong and calm with a warm confident smile, relaxed open posture, steady peaceful expression, soft warm light behind him.
Large bold left-aligned headline text at the top reads: BE TYPE 2.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Show up tomorrow.
Ordinary is enough.
At the bottom in bold text: Follow @stillmeditation.app for Day 70
Spell every word correctly. The username is @stillmeditation.app — spell it exactly as written."

echo ""
echo "=== Day 69 Complete ==="
