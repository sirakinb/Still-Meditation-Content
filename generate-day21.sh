#!/bin/bash
# Generate Day 21 slides: "21 Days of Meditation: What's Changed" (CHECK-IN)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day21"

mkdir -p "$OUTPUT_DIR"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Background: warm zen meditation room with wooden floors, soft natural light, green plants — UNLESS the scene calls for another setting. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation for TikTok. Only ONE instance of the mascot per image — never add miniature versions or icons of the character."

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

generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The muscular purple humanoid mascot is sitting calmly cross-legged in a meditation pose, eyes softly closed, peaceful half-smile, looking grounded. Warm golden light streaming in from the side.
Large bold left-aligned headline text at the top reads: 3 WEEKS IN. LET'S TALK ABOUT WHAT'S ACTUALLY HAPPENING."

generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot is standing upright, looking slightly to the side with a calm, reflective expression. Arms relaxed at his sides.
Large bold left-aligned headline text at the top reads: 21 DAYS OF MEDITATION: WHAT'S CHANGED
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The changes are quiet. Most people miss them. Here are the 4 shifts happening right now."

generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot is sitting upright with eyes slightly open, a small visible thought bubble swirl above his head that he is calmly observing — not caught up in it. Look of gentle awareness.
Large bold left-aligned headline text at the top reads: 1. YOU CATCH YOURSELF MID-SPIRAL
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You start spinning about something, then notice you're spinning. That noticing used to take hours. Now it takes seconds. The gap is widening."

generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot is standing calmly with a small knowing smirk, shoulders relaxed, while cartoon stress symbols (spilled coffee, question mark) float harmlessly around him — clearly not rattling him.
Large bold left-aligned headline text at the top reads: 2. LESS REACTIVE TO SMALL STUFF
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The slow driver. The loud coworker. The spilled coffee. Still happens — but the 0 to 100 reaction is shorter. Sometimes you don't snap at all."

generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot is lying peacefully in bed with eyes closed, one hand resting on chest, soft moonlight through a window, a crescent moon and stars visible. Deeply asleep, relaxed face.
Large bold left-aligned headline text at the top reads: 3. SLEEP COMES EASIER
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: You're falling asleep faster. Not every night, but enough to notice. Your nervous system is learning how to power down on command."

generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot is doing a body scan, one hand on his jaw and the other on his shoulder, with a subtle look of curious self-awareness. Small glowing highlight dots on his jaw, shoulders, and chest showing tension spots.
Large bold left-aligned headline text at the top reads: 4. YOU FEEL HIDDEN TENSION
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Clenched jaw at 2pm. Shoulders at your ears. A held breath when bad news hits. You're not more tense — you're more aware. Awareness is step one of release."

generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands confidently, one fist slightly raised in quiet determination, looking forward with focus and warmth. A subtle progress bar or trail of footsteps behind him suggests momentum.
Large bold left-aligned headline text at the top reads: THE HABIT IS FORMING. DON'T STOP.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Research says 66 days for full automaticity. You're 1/3 of the way there.
At the bottom in bold text: Follow @stillmeditation for Day 22"

generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands confidently, one fist slightly raised in quiet determination, looking forward with focus and warmth. A subtle progress bar or trail of footsteps behind him suggests momentum.
Large bold left-aligned headline text at the top reads: THE HABIT IS FORMING. DON'T STOP.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Research says 66 days for full automaticity. You're 1/3 of the way there.
At the bottom in bold text: Follow @stillmeditation.app for Day 22"

echo ""
echo "=== Day 21 Complete ==="
