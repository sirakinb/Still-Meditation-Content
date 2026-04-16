#!/bin/bash
# Generate Day 12 TikTok slides: "I Don't Have Time to Meditate" (MYTH)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day12"

mkdir -p "$OUTPUT_DIR"

STYLE="Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Background: warm zen meditation room with wooden floors, soft natural light, green plants. DO NOT include any text branding or logo anywhere. Light warm background with rounded corners. Text should be bold, large, left-aligned, and highly readable for mobile viewing. 4:5 portrait orientation for TikTok. Only ONE instance of the mascot per image — never add miniature versions or icons of the character."

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
The scene: The muscular purple humanoid mascot is holding up his phone with a slight smirk, raising one eyebrow knowingly at the viewer.
Large bold left-aligned headline text at the top reads: YOU SCROLLED TO THIS POST. YOU HAVE TIME TO MEDITATE."

generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The muscular purple humanoid mascot is standing with arms crossed, looking confidently at the camera. A wall clock visible behind him.
Large bold left-aligned headline text at the top reads: THE BIGGEST MYTH ABOUT MEDITATION
Below in medium bold text: That you need 30 minutes, a quiet room, and perfect silence. None of that is true."

generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The muscular purple humanoid mascot sitting cross-legged in meditation. A small clock showing '5 MIN' visible nearby.
Large bold left-aligned headline text at the top reads: 5 MINUTES IS ENOUGH.
LEAVE A CLEAR GAP between headline and body.
Below in a separate text block in medium bold text: Just 5 to 10 minutes of daily meditation produces measurable changes in stress, focus, and emotional regulation in just 8 weeks."

generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: Mascot meditating peacefully on the left. Calendar with checkmarks across multiple days on the right.
Large bold left-aligned headline text at the top reads: CONSISTENCY BEATS DURATION
Below in medium bold text: 5 minutes x 6 days a week beats 30 minutes once a week. Your brain rewires through repetition, not marathon sessions."

generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot is brushing his teeth in front of a bathroom mirror, looking at the viewer with a knowing expression.
Large bold left-aligned headline text at the top reads: YOU BRUSHED YOUR TEETH TODAY
Below in medium bold text: That took 2 minutes and you didn't think about it. Meditation can be that simple. Stack it onto something you already do."

generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sitting calmly with eyes closed, taking deep breaths.
Large bold left-aligned headline text at the top reads: 5 MINUTES YOU ALREADY HAVE
Below in medium bold text: Before you check your phone in the morning. Waiting for your coffee to brew. Right before bed. Pick one. Start tomorrow."

generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot standing with hands on his hips, confident and a little playful.
Large bold left-aligned headline text at the top reads: STOP WAITING FOR THE PERFECT MOMENT
Below in medium bold text: It will not come. 5 minutes today is more powerful than 30 minutes someday. Save this and start tomorrow.
At the bottom in bold text: Follow @stillmeditation for Day 13"

generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot standing with hands on his hips, confident and a little playful.
Large bold left-aligned headline text at the top reads: STOP WAITING FOR THE PERFECT MOMENT
Below in medium bold text: It will not come. 5 minutes today is more powerful than 30 minutes someday. Save this and start tomorrow.
At the bottom in bold text: Follow @stillmeditation.app for Day 13"

echo ""
echo "=== Day 12 Complete ==="
