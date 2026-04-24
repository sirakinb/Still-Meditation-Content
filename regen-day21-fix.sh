#!/bin/bash
# Regenerate Day 21 slides 4 and 6 with tighter prompts and shorter body copy
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day21"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Background: warm zen meditation room with wooden floors, soft natural light, green plants — UNLESS the scene calls for another setting. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

generate_slide() {
  local slide_num=$1
  local prompt=$2
  local filename="${OUTPUT_DIR}/slide${slide_num}.png"

  echo "Generating Slide ${slide_num}..."
  response=$(curl -s -X POST "${ENDPOINT}" \
    -H "x-goog-api-key: ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{\"contents\":[{\"parts\":[{\"text\": $(echo "$prompt" | jq -Rs .)}]}],\"generationConfig\":{\"responseModalities\":[\"TEXT\",\"IMAGE\"]}}")
  echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' | base64 -d > "$filename"
  echo "✓ Slide ${slide_num} saved"
}

# Slide 4: mascot shifted to the right edge, NO props near text; shorter body copy so nothing gets clipped.
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is drawn on the FAR RIGHT, small enough to fit entirely in the right 40%, with NOTHING in the left text zone. No coffee cup, no icons, no floating symbols anywhere near the text.
The scene: The mascot stands calmly on the right side with arms relaxed, a small warm half-smile, shoulders down. His eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — absolutely NOT glowing, NOT empty, NOT white-only, NOT sinister. Match the friendly expression of a fitness influencer mascot. No speech bubbles or props in the scene.
Large bold left-aligned headline text at the top reads: 2. LESS REACTIVE TO SMALL STUFF
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text (keep it short, do not clip):
The slow driver. The loud coworker. Small stuff still happens — the 0 to 100 reaction is just shorter. Sometimes you don't snap at all."

# Slide 6: shorter, cleaner body copy that cannot be garbled; mascot sized to leave clear text lane.
echo "=== Done ==="
exit 0

# (Slide 6 already looks correct; skipping regen.)
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is drawn on the FAR RIGHT, with NOTHING in the left text zone.
The scene: The mascot is standing on the right side, one hand gently touching his jaw, eyes softly open with a curious, self-aware expression. Small glowing highlight dots appear on his jaw, shoulder, and chest to indicate tension spots — all dots stay on his body in the right 40%.
Large bold left-aligned headline text at the top reads: 4. YOU FEEL HIDDEN TENSION
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text (render EXACTLY these three short lines, do not merge or drop any):
Clenched jaw. Tight shoulders. A held breath.
You're not more tense — you're more aware.
Awareness is step one of release."

echo ""
echo "=== Day 21 fixes complete ==="
