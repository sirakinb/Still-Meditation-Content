#!/bin/bash
# Generate Day 23 slides: "Walking Meditation: Mindfulness Without Sitting" (TUTORIAL)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day23"

mkdir -p "$OUTPUT_DIR"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm outdoor path or wooden floor with soft natural light and green plants — UNLESS the scene calls for another setting. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

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

# Slide 1 — Hook
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot is mid-stride on a peaceful path, one foot raised, arms relaxed at his sides. Expression is calm and aware — eyes open, taking in the surroundings. Soft dappled light suggests a quiet outdoor walk.
Large bold left-aligned headline text at the top reads: HATE SITTING STILL?
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: THIS MEDITATION IS FOR YOU."

# Slide 2 — Title card
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot walks with purpose along a calm path, one foot forward, looking ahead with a focused, grounded expression. Soft light and minimal background keep it clean.
Large bold left-aligned headline text at the top reads: WALKING MEDITATION
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Mindfulness without sitting. This isn't a consolation prize. It builds a different kind of attention."

# Slide 3 — How to start
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot takes a slow, deliberate step forward — weight shifting, foot just lifting off the ground. His expression is attentive, focused downward. Clean indoor or garden path background.
Large bold left-aligned headline text at the top reads: WALK SLOWLY. ON PURPOSE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Slower than you normally walk. Fast enough to feel the movement. Find a path 10 to 20 steps long. That's your lane."

# Slide 4 — The three phases
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot's foot is shown mid-air in a deliberate, slow step. A subtle 3-part visual cue on the right side (three small icons or arrows labeled: lifting, moving, placing) illustrates the phases. His expression is focused and curious.
Large bold left-aligned headline text at the top reads: FEEL EVERY PHASE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Lifting. Moving. Placing. Three distinct moments per step. Your only job: feel all three."

# Slide 5 — Sync breath with steps
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot walks calmly with one hand lightly on his chest, eyes forward. A simple inhale/exhale wave graphic floats near his chest on the right side. Expression is serene and rhythmic.
Large bold left-aligned headline text at the top reads: SYNC BREATH WITH STEPS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Inhale as you lift your foot. Exhale as you place it. One breath. One step. When your mind drifts, the breath brings it back."

# Slide 6 — Why it works differently
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands at the end of a short path, looking back over his shoulder with a calm, thoughtful expression — as if reviewing where he just walked. Subtle glow around his feet.
Large bold left-aligned headline text at the top reads: NOT A CONSOLATION PRIZE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Sitting builds inward focus. Walking builds outward attention — sensing your body moving through space. Both are real. Both rewire the brain."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall at the start of a path, relaxed and ready to walk. One foot slightly forward. Expression is open, grounded, inviting. Calm outdoor light.
Large bold left-aligned headline text at the top reads: YOUR TURN
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 10 minutes. Slow steps. Feel lifting, moving, placing. No cushion required.
At the bottom in bold text: Follow @stillmeditation for Day 24"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall at the start of a path, relaxed and ready to walk. One foot slightly forward. Expression is open, grounded, inviting. Calm outdoor light.
Large bold left-aligned headline text at the top reads: YOUR TURN
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 10 minutes. Slow steps. Feel lifting, moving, placing. No cushion required.
At the bottom in bold text: Follow @stillmeditation.app for Day 24"

echo ""
echo "=== Day 23 Complete ==="
