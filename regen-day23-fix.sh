#!/bin/bash
# Regen Day 23 — fix slide 5 (Exhale duplication) and slide 7 TikTok (truncated headline)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day23"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm outdoor path or wooden floor with soft natural light and green plants. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

generate_slide() {
  local slide_num=$1
  local prompt=$2
  local filename="${OUTPUT_DIR}/slide${slide_num}.png"

  echo "Regenerating Slide ${slide_num}..."
  response=$(curl -s -X POST "${ENDPOINT}" \
    -H "x-goog-api-key: ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{\"contents\":[{\"parts\":[{\"text\": $(echo "$prompt" | jq -Rs .)}]}],\"generationConfig\":{\"responseModalities\":[\"TEXT\",\"IMAGE\"]}}")
  echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' | base64 -d > "$filename"
  echo "✓ Slide ${slide_num} saved"
}

# Fix Slide 5 — shorter body copy, explicit "render exactly this text" instruction
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot walks calmly with one hand lightly on his chest, eyes forward. A simple wave graphic floats near his chest on the right side. Expression is serene and rhythmic.
Large bold left-aligned headline text at the top reads exactly: SYNC BREATH WITH STEPS
LEAVE A CLEAR GAP between headline and body.
Render EXACTLY this body text — do not repeat, duplicate, or alter any word:
Line 1: Inhale as you lift.
Line 2: Exhale as you place.
Line 3: One breath. One step.
Line 4: Mind drifts? Breath brings it back."

# Fix Slide 7 — TikTok variant, shorten headline to prevent truncation
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall at the start of a path, relaxed and ready to walk. One foot slightly forward. Expression is open, grounded, inviting. Calm outdoor light.
Render EXACTLY this headline text at the top in large bold left-aligned letters: YOUR TURN.
LEAVE A CLEAR GAP between headline and body.
Render EXACTLY this body text below — do not alter any word:
Line 1: 10 minutes.
Line 2: Slow steps.
Line 3: Feel lifting, moving, placing.
Line 4: No cushion required.
At the bottom in bold text render exactly: Follow @stillmeditation for Day 24"

echo ""
echo "=== Day 23 Regen Fix Complete ==="
