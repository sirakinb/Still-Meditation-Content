#!/bin/bash
# Generate Day 55 slides: "The meditator's paradox: trying without trying" — MOTIVATION
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day55"

mkdir -p "$OUTPUT_DIR"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm zen meditation room with wooden floors, soft natural light, green plants — UNLESS the scene calls for another setting. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

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
  if [ -n "$err" ]; then echo "✗ Slide ${slide_num} FAILED: $err" >&2; exit 1; fi
  data=$(echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data')
  if [ -z "$data" ] || [ "$data" = "null" ]; then
    echo "✗ Slide ${slide_num} FAILED: no image data" >&2
    echo "$response" | head -c 600 >&2; exit 1
  fi
  echo "$data" | base64 -d > "$filename"
  size=$(stat -f%z "$filename" 2>/dev/null || stat -c%s "$filename")
  if [ "$size" -lt 10000 ]; then echo "✗ Slide ${slide_num} FAILED: ${size} bytes" >&2; exit 1; fi
  echo "✓ Slide ${slide_num} saved (${size} bytes)"
}

# Slide 1 — Hook
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in meditation pose with a slightly frustrated brow furrowed expression, hands clenched tight on his knees, body tense, soft natural light.
Large bold left-aligned headline text at the top reads: TRY HARDER.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Get worse."

# Slide 2 — The paradox
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with a thoughtful expression, one hand on his chin, calm focused posture.
Large bold left-aligned headline text at the top reads: THE PARADOX
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Every skill rewards
effort. This one
punishes it."

# Slide 3 — The trap
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in lotus pose, jaw clenched, eyebrows tense, gripping his own knees too hard, soft natural light.
Large bold left-aligned headline text at the top reads: THE TRAP
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Forcing focus
creates the tension
you hate."

# Slide 4 — The shift
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged with a soft relaxed smile, shoulders dropped, hands resting open on his knees, eyes softly closed.
Large bold left-aligned headline text at the top reads: THE SHIFT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Stop straining.
Start noticing.
Pressure dissolves."

# Slide 5 — The method
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in meditation pose, calm peaceful expression, one hand gently resting on his heart, eyes softly closed.
Large bold left-aligned headline text at the top reads: THE WAY
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Place attention.
When it wanders,
gently return."

# Slide 6 — Outcome
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands tall with a soft serene smile, shoulders relaxed and open, warm soft glow around him.
Large bold left-aligned headline text at the top reads: THE PROOF
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Less effort.
More presence.
Deeper stillness."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 40% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a confident half-smile, peaceful posture, warm glow around him.
At the top in large bold left-aligned text: TRY IT NOW.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines, EXACTLY as written:
Stop trying.
Just sit.
At the bottom in bold smaller text: Follow @stillmeditation for Day 56
Do NOT write the words 'Line 1' or 'Line 2' or any labels — those are just formatting hints. Spell every word correctly."

# Slide 7 — IG variant
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
Layout: The TOP 40% of the card is CLEAR for text — no mascot, no body parts, no plants near the text. The mascot stands fully in the BOTTOM HALF, centered, with head BELOW the body text. Text and mascot must NEVER overlap.
The scene: The mascot stands tall and calm with a confident half-smile, peaceful posture, warm glow around him.
At the top in large bold left-aligned text: TRY IT NOW.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text on TWO lines, EXACTLY as written:
Stop trying.
Just sit.
At the bottom in bold smaller text: Follow @stillmeditation.app for Day 56
Do NOT write the words 'Line 1' or 'Line 2' or any labels — those are just formatting hints. Spell every word correctly."

echo ""
echo "=== Day 55 Complete ==="
