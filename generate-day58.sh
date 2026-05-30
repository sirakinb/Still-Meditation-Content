#!/bin/bash
# Generate Day 58 slides: "Extended breathwork session: 10-minute flow" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day58"

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
The scene: The mascot sits cross-legged in a calm meditation pose, eyes softly closed, both hands resting gently on his knees, chest rising with a deep steady breath, soft warm golden light surrounding him.
Large bold left-aligned headline text at the top reads: 10-MINUTE
BREATHWORK SESSION
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: A complete flow.
Warm-up to wind-down.
This is how it's done."

# Slide 2 — Why structure matters
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands tall with a calm authoritative expression, one hand raised open as if presenting, confident relaxed posture.
Large bold left-aligned ALL-CAPS section header at the top reads: WHY STRUCTURE MATTERS
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Breathwork without
a sequence is just
deep breathing.
Structure trains your
nervous system."

# Slide 3 — Min 1–2: Diaphragmatic warm-up
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright with both hands resting gently on his belly, eyes softly closed, a relaxed focused expression, inhaling slowly and deeply.
Large bold left-aligned ALL-CAPS section header at the top reads: MIN 1–2: WARM-UP
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Diaphragmatic breath.
Hand on belly.
Feel it rise and fall.
Prepare the system."

# Slide 4 — Min 3–5: Alternate nostril breathing
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation pose with his right hand raised, index finger gently pressing beside his nose in alternate nostril breathing position, calm focused expression.
Large bold left-aligned ALL-CAPS section header at the top reads: MIN 3–5: BALANCE
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Alternate nostril
breathing.
Left. Right. Left.
Balance both hemispheres."

# Slide 5 — Min 6–8: Ujjayi with 2:1 ratio
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with an upright steady posture, eyes softly closed, a slight constriction at the throat suggesting Ujjayi breath, calm ocean-like focus in his expression.
Large bold left-aligned ALL-CAPS section header at the top reads: MIN 6–8: INTENSITY
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Ujjayi breath.
Inhale 4 counts.
Exhale 8 counts.
The 2:1 ratio activates calm."

# Slide 6 — Min 9–10: Return to natural breath
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits completely still in a deeply relaxed open posture, hands loose on knees, eyes softly half-open, a quiet peaceful expression as if observing stillness itself.
Large bold left-aligned ALL-CAPS section header at the top reads: MIN 9–10: RETURN
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Let the breath
go natural.
Don't control it.
Just observe."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands confident and calm, a warm half-smile on his face, both hands open and relaxed at his sides, soft golden light around him.
Large bold left-aligned headline text at the top reads: TEN MINUTES.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: That is all it takes
to move through a
complete breathwork flow.
Do it tonight.
At the bottom in bold text: Follow @stillmeditation for Day 59"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands confident and calm, a warm half-smile on his face, both hands open and relaxed at his sides, soft golden light around him.
Large bold left-aligned headline text at the top reads: TEN MINUTES.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: That is all it takes
to move through a
complete breathwork flow.
Do it tonight.
At the bottom in bold text: Follow @stillmeditation.app for Day 59"

echo ""
echo "=== Day 58 Complete ==="
