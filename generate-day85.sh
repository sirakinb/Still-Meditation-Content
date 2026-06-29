#!/bin/bash
# Generate Day 85 slides: "Build your personal meditation practice plan" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day85"

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
The scene: The mascot stands confidently with arms crossed, a calm knowing smile, surrounded by subtle floating icons representing different meditation techniques — breath, heart, open sky — soft warm light.
Large bold left-aligned headline text at the top reads: YOU'VE LEARNED
15+ TECHNIQUES.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Now it's time to build
YOUR practice.
Not someone else's."

# Slide 2 — The Framework
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits in meditation pose, one hand on chest, one in lap, peaceful grounded expression.
Large bold left-aligned headline text at the top reads: THE FRAMEWORK
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Every strong daily
practice has 3 pillars:
Ground. Heart. Awareness."

# Slide 3 — Pillar 1: GROUND IT
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged with both hands resting on knees, eyes closed, deeply settled, calm earthy energy around him.
Large bold left-aligned headline text at the top reads: PILLAR 1: GROUND IT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Breath anchor
or body scan.
Starts every session. Brings you in."

# Slide 4 — Pillar 2: OPEN THE HEART
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation pose with one hand gently on his chest, a soft warm golden glow radiating from his heart area, eyes softly closed, peaceful expression.
Large bold left-aligned headline text at the top reads: PILLAR 2: OPEN THE HEART
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Loving-kindness
or compassion.
Softens the nervous system."

# Slide 5 — Pillar 3: EXPAND AWARENESS
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in open awareness pose, hands resting open on knees, eyes half-open, a sense of vast spacious calm around him, soft light.
Large bold left-aligned headline text at the top reads: PILLAR 3: EXPAND AWARENESS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Open awareness
or choiceless.
No target. No grip. Just presence."

# Slide 6 — BUILD YOUR SCHEDULE
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits at a simple desk with a small journal open, pencil in hand, calm focused expression, planning with intention.
Large bold left-aligned headline text at the top reads: BUILD YOUR SCHEDULE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Pick your time.
Start at 10 minutes.
Rotate techniques weekly.
Consistency beats intensity."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident with a calm proud smile, arms relaxed, soft warm light around him, a sense of arrival and ownership.
Large bold left-aligned headline text at the top reads: YOUR PRACTICE.
YOUR WAY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You have the tools.
Now build the ritual.
At the bottom in bold text: Follow @stillmeditation for Day 86"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident with a calm proud smile, arms relaxed, soft warm light around him, a sense of arrival and ownership.
Large bold left-aligned headline text at the top reads: YOUR PRACTICE.
YOUR WAY.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You have the tools.
Now build the ritual.
At the bottom in bold text: Follow @stillmeditation.app for Day 86"

echo ""
echo "=== Day 85 Complete ==="
