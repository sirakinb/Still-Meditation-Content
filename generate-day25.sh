#!/bin/bash
# Generate Day 25 slides: "Cyclic sighing: the Stanford-approved calm hack" (TUTORIAL)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day25"

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
  echo "$response" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' | base64 -d > "$filename"
  echo "✓ Slide ${slide_num} saved"
}

# Slide 1 — Hook
generate_slide 1 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands with a relaxed, confident posture, mid-exhale through the mouth. A subtle visible breath wave streams from his lips. Expression is calm, almost surprised at how good it feels. Warm soft lighting.
Large bold left-aligned headline text at the top reads: STANFORD FOUND THE #1 BREATHING TECHNIQUE.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: It's not what you think."

# Slide 2 — Title card
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands confidently with a calm, knowing expression. A small lung icon and a subtle breath wave float beside him on the right.
Large bold left-aligned headline text at the top reads: CYCLIC SIGHING
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The 5-minute technique that beat meditation in a Stanford study."

# Slide 3 — The study
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands holding a small clipboard with a subtle academic seal graphic visible only on the right side. Expression is focused and impressed.
Large bold left-aligned headline text at the top reads: THE 2023 STUDY
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Stanford and Huberman tested 4 techniques for 5 minutes a day. Cyclic sighing won — biggest mood boost, lowest anxiety."

# Slide 4 — Step 1: double inhale
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot inhales through his nose with chest expanded, a small upward breath arrow near his nose on the right side. Expression is focused, almost playful.
Large bold left-aligned headline text at the top reads: STEP 1: DOUBLE INHALE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: One full breath through the nose. Then a small top-up sip on top. Both through the nose."

# Slide 5 — Step 2: long exhale
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot exhales slowly through his mouth, a long visible breath wave streaming down and away. Expression is calm and settled.
Large bold left-aligned headline text at the top reads: STEP 2: LONG EXHALE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Slow extended exhale through the mouth. Make it longer than the inhale. Empty all the way out."

# Slide 6 — Why it works
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot points calmly toward his chest area, a subtle glowing lung outline visible on the right side. Expression is calm and explanatory.
Large bold left-aligned headline text at the top reads: WHY IT WORKS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The double inhale reopens collapsed lung sacs. The long exhale dumps CO2 fast. Your nervous system downshifts in seconds."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands with eyes softly closed, mid-exhale through the mouth, a soft breath wave drifting away. Expression is serene and settled. Soft warm light around him.
Large bold left-aligned headline text at the top reads: TRY IT NOW.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Double inhale through the nose. Long exhale through the mouth. Repeat for 5 minutes.
At the bottom in bold text: Follow @stillmeditation for Day 26"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands with eyes softly closed, mid-exhale through the mouth, a soft breath wave drifting away. Expression is serene and settled. Soft warm light around him.
Large bold left-aligned headline text at the top reads: TRY IT NOW.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Double inhale through the nose. Long exhale through the mouth. Repeat for 5 minutes.
At the bottom in bold text: Follow @stillmeditation.app for Day 26"

echo ""
echo "=== Day 25 Complete ==="
