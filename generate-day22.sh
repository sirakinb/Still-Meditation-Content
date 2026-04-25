#!/bin/bash
# Generate Day 22 slides: "The Day 25 Breakthrough is Real" (MOTIVATION)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day22"

mkdir -p "$OUTPUT_DIR"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: warm zen meditation room with wooden floors, soft natural light, green plants — UNLESS the scene calls for another setting. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation. Only ONE instance of the mascot per image."

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
The scene: The mascot is sitting in a meditation pose, eyes softly closed, with a peaceful and slightly surprised expression — as if just noticing inner stillness. A faint glowing aura around his head suggests a quiet inner moment. Warm side lighting.
Large bold left-aligned headline text at the top reads: SOMETHING CLICKS AROUND DAY 25.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: SCIENCE EXPLAINS WHY."

# Slide 2 — Title card
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot stands confidently with arms relaxed, looking forward with a calm, grounded expression. A subtle '25' or progress indicator can hover above his head as a small glowing element on the right side only.
Large bold left-aligned headline text at the top reads: THE DAY 25 BREAKTHROUGH IS REAL
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: If you've been consistent for 3 weeks, the most reported beginner phenomenon is right in front of you."

# Slide 3 — What it feels like
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot is sitting cross-legged with eyes softly closed, a subtle warm glow surrounding him, expression peaceful and slightly awed. The room around him appears slightly faded or softened.
Large bold left-aligned headline text at the top reads: THE FIRST MOMENT OF MENTAL QUIET
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 60 to 90 seconds where the noise just stops. No effort. No technique. Just space."

# Slide 4 — When
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands relaxed with a small confident smile, looking ahead. A simple horizontal calendar-like row of 3-4 small dots/checkmarks behind him on the right side suggests progress.
Large bold left-aligned headline text at the top reads: IT HITS BETWEEN DAY 25 AND 28
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Brief but unmistakable. Most meditators describe it the exact same way."

# Slide 5 — Why (brain science)
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot points calmly at his own head with one finger, indicating his brain. A simple stylized glowing brain icon hovers next to his head on the right side. Friendly, knowing expression.
Large bold left-aligned headline text at the top reads: YOUR BRAIN IS REWIRING
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: By Week 4, studies show measurable shifts in the prefrontal cortex and amygdala. Your default starts changing from low-grade alarm to alert calm."

# Slide 6 — Why (effort drops)
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot is sitting in meditation, shoulders dropped, hands resting easily on his knees, eyes softly closed. Body language is loose, unforced, surrendered. No tension anywhere.
Large bold left-aligned headline text at the top reads: YOU STOP TRYING SO HARD
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Weeks 1-3 are pure effort. By Week 4, the over-trying drops. That's when the quiet sneaks in."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands strong and confident, one fist subtly raised in determination, looking forward with focus. A glowing horizontal progress bar behind him is roughly 1/3 filled, visualizing momentum.
Large bold left-aligned headline text at the top reads: DON'T QUIT BEFORE THE BREAKTHROUGH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 66 days for full habit formation. You're at Day 22. The most rewarding stretch is right in front of you.
At the bottom in bold text: Follow @stillmeditation for Day 23"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands strong and confident, one fist subtly raised in determination, looking forward with focus. A glowing horizontal progress bar behind him is roughly 1/3 filled, visualizing momentum.
Large bold left-aligned headline text at the top reads: DON'T QUIT BEFORE THE BREAKTHROUGH
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 66 days for full habit formation. You're at Day 22. The most rewarding stretch is right in front of you.
At the bottom in bold text: Follow @stillmeditation.app for Day 23"

echo ""
echo "=== Day 22 Complete ==="
