#!/bin/bash
# Generate Day 60 slides: "60 days: the identity shift" — CHECK-IN
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day60"

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
The scene: The mascot stands tall with quiet confidence, a calm half-smile, arms relaxed at his sides, soft warm golden light around him, the look of someone who has changed.
Large bold left-aligned headline text at the top reads: 60 DAYS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You're not someone
who meditates.
You ARE a meditator."

# Slide 2 — Sleep
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot rests peacefully in a relaxed posture, eyes softly closed, a calm restful expression, soft warm light around him.
Large bold left-aligned ALL-CAPS section header at the top reads: SLEEP
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Up to 30% better.
You fall asleep faster.
You stay asleep."

# Slide 3 — Focus
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in a focused meditation pose, eyes softly closed, deep concentration on his face, very still and steady.
Large bold left-aligned ALL-CAPS section header at the top reads: FOCUS
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Attention span tripled.
Deep work feels
natural now."

# Slide 4 — Heart rate
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged calmly, one hand resting gently over his chest, eyes softly closed, a serene grounded expression.
Large bold left-aligned ALL-CAPS section header at the top reads: HEART RATE
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Resting rate dropped.
Your body runs
quieter now."

# Slide 5 — Anxiety
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall with shoulders relaxed, a calm steady expression, soft light around him, the look of someone who carries less weight than before.
Large bold left-aligned ALL-CAPS section header at the top reads: ANXIETY
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: From dominant
to manageable.
You feel it. It passes."

# Slide 6 — The shift
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in an effortless steady meditation pose, eyes softly closed, a quiet knowing smile, the look of someone home in the practice.
Large bold left-aligned ALL-CAPS section header at the top reads: THE SHIFT
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Not 'will I sit?'
The new question is
'when do I sit?'"

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with a quiet confident smile, both hands open and relaxed at his sides, soft golden light around him, the look of someone fully transformed.
Large bold left-aligned headline text at the top reads: 60 DAYS IN.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: This is who
you are now.
Keep going.
At the bottom in bold text: Follow @stillmeditation for Day 61"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with a quiet confident smile, both hands open and relaxed at his sides, soft golden light around him, the look of someone fully transformed.
Large bold left-aligned headline text at the top reads: 60 DAYS IN.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: This is who
you are now.
Keep going.
At the bottom in bold text: Follow @stillmeditation.app for Day 61"

echo ""
echo "=== Day 60 Complete ==="
