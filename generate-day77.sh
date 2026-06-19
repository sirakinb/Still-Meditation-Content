#!/bin/bash
# Generate Day 77 slides: "Design your perfect 20-minute practice" — CHALLENGE
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day77"

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
The scene: The mascot sits cross-legged in a meditation pose, eyes closed in calm confidence, one hand resting over his heart and the other open on his knee — as if in self-directed practice, no phone, no guide needed.
Large bold left-aligned headline text at the top reads: CREATE YOUR OWN
20-MINUTE PRACTICE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: No guide needed.
Just you and 5 elements.
Tonight."

# Slide 2 — WHY BUILD YOUR OWN
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits in a proud, self-assured meditation posture, eyes softly closed, a quiet confident expression — the sense that he needs no teacher right now.
Large bold left-aligned headline text at the top reads: WHY BUILD YOUR OWN
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: The best practice
is the one you do.
You know what works.
Time to own it."

# Slide 3 — STEP 1
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright, eyes closed, with a slow steady breath visible as a soft glow around his chest — a breathwork warm-up pose, calm and focused.
Large bold left-aligned headline text at the top reads: STEP 1
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Breathwork warm-up.
3 minutes.
Box breath, 4-7-8,
or Wim Hof lite.
Signal: we're shifting gears."

# Slide 4 — STEPS 2 AND 3
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with a single candle in front of him, eyes softly focused, then transitions to hands open on knees — showing both focused attention and open awareness in one serene pose.
Large bold left-aligned headline text at the top reads: STEPS 2 AND 3
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 5 min: focused attention.
Anchor to breath or candle.
5 min: open awareness
or loving-kindness.
Let the anchor go."

# Slide 5 — STEP 4
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with both hands resting on knees, completely open and relaxed, eyes gently closed — no technique, no effort, just pure open sitting awareness.
Large bold left-aligned headline text at the top reads: STEP 4
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Choiceless awareness.
5 minutes.
No anchor. No technique.
Sit with whatever arises.
No training wheels."

# Slide 6 — STEP 5
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with both hands on his heart, eyes closed, a warm soft smile on his face — a closing gratitude pose radiating quiet fullness and contentment.
Large bold left-aligned headline text at the top reads: STEP 5
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Gratitude close.
2 minutes.
Three things. Feel each one.
Do not rush.
Seal the session."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with arms slightly open and a calm proud expression — the look of someone who just completed their own self-designed practice and feels genuinely good about it.
Large bold left-aligned headline text at the top reads: YOUR PRACTICE.
YOUR RULES.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Nothing to buy.
Nobody to follow.
Just 20 minutes
and what you already know.
At the bottom in bold text: Follow @stillmeditation for Day 78"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with arms slightly open and a calm proud expression — the look of someone who just completed their own self-designed practice and feels genuinely good about it.
Large bold left-aligned headline text at the top reads: YOUR PRACTICE.
YOUR RULES.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Nothing to buy.
Nobody to follow.
Just 20 minutes
and what you already know.
At the bottom in bold text: Follow @stillmeditation.app for Day 78"

echo ""
echo "=== Day 77 Complete ==="
