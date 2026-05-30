#!/bin/bash
# Generate Day 59 slides: "Meditate for 20 minutes today" — CHALLENGE
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day59"

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
The scene: The mascot sits cross-legged in a strong steady meditation pose, eyes softly closed, spine tall, both hands resting calmly on his knees, a quiet confident expression, soft warm golden light around him.
Large bold left-aligned headline text at the top reads: YOUR FIRST
20-MINUTE SIT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You're ready.
Today's the day."

# Slide 2 — Why 20 minutes
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands tall with a calm grounded expression, arms relaxed at his sides, confident posture.
Large bold left-aligned ALL-CAPS section header at the top reads: WHY 20 MINUTES
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Below 20 you skim.
At 20 you sink.
Deeper states open up."

# Slide 3 — Min 1–5: Settling
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged, just settling in, hands resting on knees, eyes softly closed, a relaxed expression as if releasing the day.
Large bold left-aligned ALL-CAPS section header at the top reads: MIN 1–5: SETTLE
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Drop in.
Notice the body.
Let the mind arrive."

# Slide 4 — Min 5–10: Focused attention
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in a focused meditation pose, eyes softly closed, deep concentration on his face, very still and steady.
Large bold left-aligned ALL-CAPS section header at the top reads: MIN 5–10: FOCUS
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Anchor on the breath.
Return every time
the mind wanders."

# Slide 5 — Min 10–15: Open awareness
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with a spacious open posture, eyes softly closed, palms facing up on his knees, a quiet receptive expression.
Large bold left-aligned ALL-CAPS section header at the top reads: MIN 10–15: OPEN
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Drop the anchor.
Watch what arises.
Don't chase. Don't push."

# Slide 6 — Min 15–20: Rest
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits completely still in a deeply relaxed pose, eyes softly closed, a peaceful expression of pure rest, almost dissolving into the moment.
Large bold left-aligned ALL-CAPS section header at the top reads: MIN 15–20: REST
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Stop doing.
Rest in what's here.
This is the point."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with a quiet confident half-smile, both hands open and relaxed at his sides, soft golden light around him, a sense of accomplishment.
Large bold left-aligned headline text at the top reads: 20 MINUTES.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You've been building
to this sit.
Do it today.
At the bottom in bold text: Follow @stillmeditation for Day 60"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with a quiet confident half-smile, both hands open and relaxed at his sides, soft golden light around him, a sense of accomplishment.
Large bold left-aligned headline text at the top reads: 20 MINUTES.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You've been building
to this sit.
Do it today.
At the bottom in bold text: Follow @stillmeditation.app for Day 60"

echo ""
echo "=== Day 59 Complete ==="
