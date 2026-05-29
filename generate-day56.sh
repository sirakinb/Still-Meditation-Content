#!/bin/bash
# Generate Day 56 slides: "Mantra meditation: the power of repetition" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day56"

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
The scene: The mascot sits cross-legged in deep meditation, eyes closed, lips relaxed, one hand resting on each knee, a soft warm glow surrounding him. Peaceful, still, serene expression.
Large bold left-aligned headline text at the top reads: ONE WORD.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Repeated silently.
For 10 minutes.
Try it."

# Slide 2 — What it is
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot holds one hand open in front of him, palm up, as if presenting a simple gift — relaxed, inviting expression.
Large bold left-aligned ALL-CAPS section header at the top reads: WHAT IT IS
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Pick any word:
Peace. Om. Let go.
Repeat silently with each exhale."

# Slide 3 — How to start
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright in meditation pose, eyes softly closed, hands resting on knees, relaxed breathing posture.
Large bold left-aligned ALL-CAPS section header at the top reads: HOW TO START
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Close your eyes.
Breathe naturally.
With each exhale — say your word silently."

# Slide 4 — Why it works
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits calmly with a knowing half-smile, one finger tapping his temple gently, thoughtful but peaceful expression.
Large bold left-aligned ALL-CAPS section header at the top reads: WHY IT WORKS
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Your thinking mind needs a job.
The mantra gives it one.
That paradox quiets everything."

# Slide 5 — When thoughts arrive
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits steady and grounded, eyes closed, one hand raised gently as if acknowledging a passing cloud — calm, unshaken posture.
Large bold left-aligned ALL-CAPS section header at the top reads: WHEN THOUGHTS ARRIVE
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Notice them.
Return to your word.
That return IS the practice."

# Slide 6 — What to expect
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in deep stillness, soft serene expression, a subtle glow emanating from around his heart — eyes closed, complete peace.
Large bold left-aligned ALL-CAPS section header at the top reads: WHAT TO EXPECT
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Silence arrives in gaps.
Between repetitions.
That is where you find it."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and peaceful, both hands clasped together at his chest in a gentle prayer or bow, warm confident smile, soft golden light behind him.
Large bold left-aligned headline text at the top reads: ONE WORD.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 10 minutes.
Tonight.
See what opens up.
At the bottom in bold text: Follow @stillmeditation for Day 57"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and peaceful, both hands clasped together at his chest in a gentle prayer or bow, warm confident smile, soft golden light behind him.
Large bold left-aligned headline text at the top reads: ONE WORD.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 10 minutes.
Tonight.
See what opens up.
At the bottom in bold text: Follow @stillmeditation.app for Day 57"

echo ""
echo "=== Day 56 Complete ==="
