#!/bin/bash
# Generate Day 72 slides: "Long-term meditators' brains are younger" (SCIENCE)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day72"

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
The scene: The mascot stands tall and confident, arms crossed, calm focused expression, soft glowing light around his head suggesting brain activity or mental sharpness.
Large bold left-aligned headline text at the top reads: MEDITATORS' BRAINS AGE SLOWER.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Scientists scanned
100 brains.
The difference was undeniable."

# Slide 2 — The UCLA Study
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands in a calm science lab or research setting, looking curious and engaged, clipboard or neutral pose.
Large bold left-aligned headline text at the top reads: THE UCLA STUDY
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 50 long-term meditators.
50 non-meditators.
Same age. Same health."

# Slide 3 — The Finding
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with a calm, amazed expression, eyebrows slightly raised, hand raised open as if presenting a surprising fact.
Large bold left-aligned headline text at the top reads: THE FINDING
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Meditators' brains:
7.5 years younger.
On average."

# Slide 4 — Practice stacks
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands strong and grounded, calm steady expression, soft warm light, posture reflecting years of confidence.
Large bold left-aligned headline text at the top reads: MORE PRACTICE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: More years of practice.
Bigger brain age gap.
It compounds over time."

# Slide 5 — What is preserved
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in a calm meditation pose, eyes softly closed, a subtle warm glow above his head suggesting brain activity and health.
Large bold left-aligned headline text at the top reads: GRAY MATTER
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Memory.
Focus. Emotional control.
Meditation keeps it intact."

# Slide 6 — What this means for you
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands upright with a calm purposeful expression, one hand on his chest, soft natural light.
Large bold left-aligned headline text at the top reads: WHAT THIS MEANS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Every session counts.
You are building
a younger brain."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident with a calm half-smile, both hands relaxed at his sides, soft warm glow around his head, strong and grounded.
Large bold left-aligned headline text at the top reads: YOUR BRAIN IS YOUR GREATEST ASSET.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Protect it.
Train it.
At the bottom in bold text: Follow @stillmeditation for Day 73"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident with a calm half-smile, both hands relaxed at his sides, soft warm glow around his head, strong and grounded.
Large bold left-aligned headline text at the top reads: YOUR BRAIN IS YOUR GREATEST ASSET.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Protect it.
Train it.
At the bottom in bold text: Follow @stillmeditation.app for Day 73"

echo ""
echo "=== Day 72 Complete ==="
