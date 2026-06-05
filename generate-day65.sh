#!/bin/bash
# Generate Day 65 slides: "Morning vs evening: which practice for which time" (QUICK TIP)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day65"

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

  # Sanity-check file size (real PNGs are >100KB; 0-byte means silent failure)
  size=$(stat -f%z "$filename" 2>/dev/null || stat -c%s "$filename")
  if [ "$size" -lt 10000 ]; then
    echo "✗ Slide ${slide_num} FAILED: output file is only ${size} bytes" >&2
    exit 1
  fi
  echo "✓ Slide ${slide_num} saved (${size} bytes)"
}

# Slide 1 — Hook
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands in the center with a confident calm expression, one hand raised pointing upward at sunrise on his left and the other hand pointing down at a crescent moon on his right, representing morning and evening. Soft warm sunrise glow on the left half of the background, cool twilight on the right half — subtle gradient, not two separate panels.
Large bold left-aligned headline text at the top reads: YOUR MORNING AND EVENING PRACTICE SHOULDN'T MATCH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Your nervous system needs
different things at sunrise
and at sunset."

# Slide 2 — Your nervous system's daily rhythm
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands upright with a calm knowing expression, arms relaxed, soft ambient light.
Large bold left-aligned ALL-CAPS header text at the top reads: YOUR NERVOUS SYSTEM
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Morning: cortisol rising,
brain coming online.
Evening: cortisol dropping,
body winding down.
Your practice should match
the direction."

# Slide 3 — Morning Practice
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands sharp and alert in bright morning light, shoulders back, energized expression, sunrise glow behind him.
Large bold left-aligned ALL-CAPS header text at the top reads: MORNING PRACTICE
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Goal: activation, not calm.
Breathwork: box breathing or
Kapalabhati — 3 to 5 min.
Meditation: focused attention,
breath anchor — 10 to 15 min."

# Slide 4 — Evening Practice
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged in a softly lit evening room, gentle moonlight, deeply relaxed and peaceful expression, eyes gently closed.
Large bold left-aligned ALL-CAPS header text at the top reads: EVENING PRACTICE
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Goal: deactivation.
Breathwork: 4-7-8 or coherent
breathing (5-5) — 3 to 5 min.
Meditation: body scan or
loving-kindness — 10 to 15 min."

# Slide 5 — Morning Breathwork Options
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands energized with a bright focused expression, light radiating from his chest, morning energy around him.
Large bold left-aligned ALL-CAPS header text at the top reads: MORNING BREATHWORK
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: Box breathing: 4 in, 4 hold,
4 out, 4 hold.
Kapalabhati: sharp exhales,
passive inhales.
Both raise alertness and
sharpen focus."

# Slide 6 — Evening Breathwork Options
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits relaxed and serene, soft evening candlelight or moonlight, eyes gently closed, deeply settled expression.
Large bold left-aligned ALL-CAPS header text at the top reads: EVENING BREATHWORK
LEAVE A CLEAR GAP between header and body.
Below in medium bold text: 4-7-8: inhale 4, hold 7,
exhale 8.
Coherent: inhale 5, exhale 5.
Long exhale activates your
vagus nerve and calms
the nervous system."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, soft warm light around him.
Large bold left-aligned headline text at the top reads: MATCH THE TOOL TO THE MOMENT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Morning: box or Kapalabhati
then focused attention.
Evening: 4-7-8 or coherent
then body scan.
Save this for your next practice.
At the bottom in bold text: Follow @stillmeditation for Day 66"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and confident, calm half-smile, both hands relaxed at his sides, soft warm light around him.
Large bold left-aligned headline text at the top reads: MATCH THE TOOL TO THE MOMENT.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Morning: box or Kapalabhati
then focused attention.
Evening: 4-7-8 or coherent
then body scan.
Save this for your next practice.
At the bottom in bold text: Follow @stillmeditation.app for Day 66"

echo ""
echo "=== Day 65 Complete ==="
