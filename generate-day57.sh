#!/bin/bash
# Generate Day 57 slides: "5 signs your meditation practice is working" — QUICK TIP
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day57"

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
The scene: The mascot stands calm and centered, a soft knowing half-smile on his face, eyes open and gentle, one hand resting over his heart. Peaceful confident posture.
Large bold left-aligned headline text at the top reads: 5 SIGNS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Your meditation
is working.
You won't notice.
Others will."

# Slide 2 — Sign 1: pause before reacting
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands relaxed, one finger gently raised near his lips as if pausing mid-thought, calm thoughtful expression.
Large bold left-aligned ALL-CAPS section header at the top reads: SIGN 1
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: You pause
before you react.
A small breath.
Then you respond."

# Slide 3 — Sign 2: notice tension early
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot rolls his shoulders slowly, eyes softly closed, a relaxed aware expression, gently noticing his body.
Large bold left-aligned ALL-CAPS section header at the top reads: SIGN 2
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: You notice tension
before it becomes pain.
Shoulders. Jaw. Chest.
You feel it early."

# Slide 4 — Sign 3: fall asleep faster
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot lies peacefully on his back with eyes closed, a calm content smile, one hand resting on his stomach — fully relaxed sleep posture.
Large bold left-aligned ALL-CAPS section header at the top reads: SIGN 3
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: You fall asleep
faster.
The mind stops looping.
Rest comes easier."

# Slide 5 — Sign 4: present in conversations
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot leans in slightly with warm attentive eyes, one hand open in a listening gesture, fully engaged friendly expression.
Large bold left-aligned ALL-CAPS section header at the top reads: SIGN 4
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: You are more
present.
People feel heard
when you listen."

# Slide 6 — Sign 5: quiet confidence
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall and grounded, shoulders relaxed, a steady confident half-smile, soft warm glow around him.
Large bold left-aligned ALL-CAPS section header at the top reads: SIGN 5
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: A quiet confidence.
You can handle
whatever comes.
No panic. Just calm."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in meditation pose, eyes softly closed, hands resting on knees, a peaceful warm smile, soft golden light surrounding him.
Large bold left-aligned headline text at the top reads: THE REAL PROOF
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: None of this
happens on the cushion.
It shows up
in your life.
At the bottom in bold text: Follow @stillmeditation for Day 58"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits cross-legged in meditation pose, eyes softly closed, hands resting on knees, a peaceful warm smile, soft golden light surrounding him.
Large bold left-aligned headline text at the top reads: THE REAL PROOF
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: None of this
happens on the cushion.
It shows up
in your life.
At the bottom in bold text: Follow @stillmeditation.app for Day 58"

echo ""
echo "=== Day 57 Complete ==="
