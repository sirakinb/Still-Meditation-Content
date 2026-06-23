#!/bin/bash
# Generate Day 79 slides: "Tummo: the inner fire breath" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day79"

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
The scene: The mascot sits cross-legged in meditation pose with a warm golden glow radiating from his midsection, eyes softly closed, calm powerful expression. Background suggests a mystical Tibetan mountain cave with soft warm firelight — a dramatic but serene setting.
Large bold left-aligned headline text at the top reads: TIBETAN MONKS RAISE THEIR BODY TEMPERATURE WITH THIS TECHNIQUE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: It is not magic.
It is breathwork.
It is called Tummo."

# Slide 2 — What is Tummo
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands with a calm confident expression, one hand gesturing open as if explaining something profound, soft warm light.
Large bold left-aligned headline text at the top reads: WHAT IS TUMMO
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Ancient Tibetan practice.
Breath plus visualization.
Generates real body heat."

# Slide 3 — Step 1: Find Your Flame
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation pose with eyes closed, one hand resting gently on his navel, a small warm flame visualized glowing softly at that point, peaceful focused expression.
Large bold left-aligned headline text at the top reads: STEP 1: FIND YOUR FLAME
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Sit and close your eyes.
Picture a small flame
glowing at your navel."

# Slide 4 — Step 2: Fuel the Fire
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright with chest expanded in a deep inhale, golden warmth radiating from his belly upward, eyes softly closed, expression of calm intensity.
Large bold left-aligned headline text at the top reads: STEP 2: FUEL THE FIRE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Inhale deeply.
Imagine breath feeding
the flame. Watch it grow."

# Slide 5 — Step 3: Exhale Through Pursed Lips
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation with lips slightly pursed in a strong exhale, a wave of warm golden energy radiating outward from his core, focused determined expression.
Large bold left-aligned headline text at the top reads: STEP 3: EXHALE FORCEFULLY
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Purse your lips.
Push the breath out strong.
Feel the fire surge."

# Slide 6 — Step 4: The Vase Breath
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits very still with eyes closed, core visibly engaged and tightened, hands resting on knees, expression of deep internal focus and power, a warm amber glow surrounds him.
Large bold left-aligned headline text at the top reads: STEP 4: THE VASE BREATH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: After 5 cycles: inhale.
Hold. Squeeze your core tight.
This seals the inner fire."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and powerful with a calm half-smile, warm golden light radiating from his entire body, grounded and glowing, hands relaxed at his sides.
Large bold left-aligned headline text at the top reads: YOUR BODY IS THE FURNACE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Tummo is the match.
Try one round today.
At the bottom in bold text: Follow @stillmeditation for Day 80"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall and powerful with a calm half-smile, warm golden light radiating from his entire body, grounded and glowing, hands relaxed at his sides.
Large bold left-aligned headline text at the top reads: YOUR BODY IS THE FURNACE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Tummo is the match.
Try one round today.
At the bottom in bold text: Follow @stillmeditation.app for Day 80"

echo ""
echo "=== Day 79 Complete ==="
