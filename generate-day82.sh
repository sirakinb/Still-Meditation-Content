#!/bin/bash
# Generate Day 82 slides: "The 3-breath reset: your anytime anywhere practice" (QUICK TIP)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day82"

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
The scene: The mascot stands centered with eyes gently closed, three glowing breath circles floating gently around his chest — one labeled ARRIVE, one ALLOW, one ALIGN. Calm and serene atmosphere, zen room background with soft warm light.
Large bold left-aligned headline text at the top reads: THE MOST USEFUL MEDITATION TECHNIQUE FITS IN 10 SECONDS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Three breaths.
Any time. Any place.
Powerful shift."

# Slide 2 — What is the 3-breath reset
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands tall with arms relaxed at his sides, calm composed expression, in the zen meditation room with warm light.
Large bold left-aligned ALL-CAPS section header at the top reads: THE 3-BREATH RESET
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: A micro-meditation for real life.
Not a full session.
Just three intentional breaths.
That is it."

# Slide 3 — Breath 1: Arrive
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot inhales slowly, chest rising, eyes half-closed in peaceful awareness, one hand resting gently on his chest. Soft golden light around him.
Large bold left-aligned ALL-CAPS section header at the top reads: BREATH 1: ARRIVE
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Inhale slowly.
Notice where you are.
Feel your feet on the floor.
Right here. Right now."

# Slide 4 — Breath 2: Allow
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot exhales, shoulders visibly relaxing downward, open hands at his sides, expression soft and accepting, tension visibly leaving his body.
Large bold left-aligned ALL-CAPS section header at the top reads: BREATH 2: ALLOW
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Exhale completely.
Accept what you are feeling.
Stressed. Tired. Anxious.
Don't fight it. Let it be."

# Slide 5 — Breath 3: Align
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands upright with focused calm energy, a faint glowing intention-symbol in front of his chest, steady grounded posture, determined yet peaceful expression.
Large bold left-aligned ALL-CAPS section header at the top reads: BREATH 3: ALIGN
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: One more breath.
Set a quiet intention.
I choose calm.
I will listen well."

# Slide 6 — When to use it
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands calmly with a slight knowing smile, in a modern setting with a glowing phone, a clock, and a coffee mug visible softly in the background — conveying daily life moments.
Large bold left-aligned ALL-CAPS section header at the top reads: USE IT ANYWHERE
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Between meetings.
Before a hard conversation.
At a red light.
After you check your phone.
Ten seconds. Real impact."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, warm soft light around him in a zen meditation room.
Large bold left-aligned headline text at the top reads: TEN SECONDS TO A CALMER YOU
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Three breaths.
Arrive. Allow. Align.
Try it right now.
At the bottom in bold text: Follow @stillmeditation for Day 83"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, warm soft light around him in a zen meditation room.
Large bold left-aligned headline text at the top reads: TEN SECONDS TO A CALMER YOU
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Three breaths.
Arrive. Allow. Align.
Try it right now.
At the bottom in bold text: Follow @stillmeditation.app for Day 83"

echo ""
echo "=== Day 82 Complete ==="
