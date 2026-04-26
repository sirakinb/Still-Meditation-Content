#!/bin/bash
# Generate Day 24 slides: "How Breathwork Rewires Your Stress Response" (SCIENCE)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day24"

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
The scene: The mascot stands with eyes closed, one hand on his chest, exhaling visibly — a soft wave of breath shown as a gentle arc leaving his mouth. Expression is deeply calm and relieved. Warm soft lighting.
Large bold left-aligned headline text at the top reads: YOUR EXHALE IS MORE POWERFUL THAN ANY ANXIETY MEDICATION.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Science."

# Slide 2 — Title card
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands confidently with a calm, knowing expression. A subtle glowing brain icon and a small lung/breath wave icon float beside him on the right. Background: soft lab or wellness setting.
Large bold left-aligned headline text at the top reads: HOW BREATHWORK REWIRES YOUR STRESS RESPONSE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: This is not wellness advice. This is neuroscience."

# Slide 3 — Stanford study
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot holds a small clipboard or paper with a subtle 'Stanford' or academic seal graphic visible on the right side only. Expression is focused and impressed, like reviewing research results.
Large bold left-aligned headline text at the top reads: THE STANFORD STUDY
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 5 minutes of exhale-emphasized breathing improved mood more than mindfulness meditation alone. Published 2023."

# Slide 4 — The 2:1 ratio
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot demonstrates breathing — chest slightly expanded for inhale, then visually settling for exhale. A simple 2:1 ratio graphic (small bar showing short inhale, long exhale) floats on the right side near him.
Large bold left-aligned headline text at the top reads: THE 2:1 RATIO
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Inhale for 4 counts. Exhale for 8 counts. The exhale is twice as long. That ratio is the signal."

# Slide 5 — Vagus nerve
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot points calmly to his own throat/chest area with one finger, indicating the vagus nerve pathway. A subtle glowing nerve-like line runs from his jaw down toward his chest on the right side. Expression is calm and explanatory.
Large bold left-aligned headline text at the top reads: YOU'RE ACTIVATING YOUR VAGUS NERVE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: A long exhale directly stimulates the vagus nerve. That triggers the parasympathetic system — your body's off switch for the stress response."

# Slide 6 — Why faster than meditation
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits cross-legged but looks alert and slightly wide-eyed — as if surprised by how quickly he feels calm. A small clock or timer icon with a lightning bolt suggests rapid effect, floating on the right side.
Large bold left-aligned headline text at the top reads: WHY IT WORKS FASTER
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Meditation changes attention. Breathwork changes physiology directly. You're not trying to feel calmer. You're making your body produce calm."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands with eyes softly closed, one hand on chest, in a deliberate exhale posture. Expression is serene and settled. Soft warm light around him.
Large bold left-aligned headline text at the top reads: TRY IT NOW.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Inhale 4 counts. Exhale 8 counts. Repeat 5 times. That's the whole thing.
At the bottom in bold text: Follow @stillmeditation for Day 25"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands with eyes softly closed, one hand on chest, in a deliberate exhale posture. Expression is serene and settled. Soft warm light around him.
Large bold left-aligned headline text at the top reads: TRY IT NOW.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Inhale 4 counts. Exhale 8 counts. Repeat 5 times. That's the whole thing.
At the bottom in bold text: Follow @stillmeditation.app for Day 25"

echo ""
echo "=== Day 24 Complete ==="
