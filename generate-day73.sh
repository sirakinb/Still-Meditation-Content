#!/bin/bash
# Generate Day 73 slides: "The Wim Hof method: breathwork's final boss" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day73"

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
The scene: The mascot stands in a powerful upright breathing stance, chest expanded, chin slightly raised, deep inhale, intense focused expression — like he is about to attempt something extraordinary. Background: cool icy mountain landscape with snow and mist (Wim Hof connection to cold).
Large bold left-aligned headline text at the top reads: THE MOST INTENSE
BREATHING TECHNIQUE
IN THE WORLD
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: (with safety rules)
Wim Hof method —
for experienced
practitioners only."

# Slide 2 — What it is
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot sits cross-legged on icy ground, calm and composed, surrounded by a subtle cool blue aura, peaceful confident expression.
Large bold left-aligned headline text at the top reads: WHAT IT IS
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: A 3-round breath
protocol that floods
your body with oxygen.
It can reduce stress,
boost energy, and
strengthen immunity."

# Slide 3 — Step 1: 30 Deep Breaths
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits in a relaxed seated position, mouth slightly open on a big inhale, chest fully expanded, one hand resting on knee, calm powerful expression.
Large bold left-aligned headline text at the top reads: STEP 1: BREATHE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: 30 deep breaths.
Full inhale through
nose or mouth.
Relaxed exhale —
let it go naturally.
No force on the out."

# Slide 4 — Step 2: Retention Hold
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits perfectly still with both hands on knees, eyes gently closed, utterly calm and motionless, as if suspended in time, soft stillness around him.
Large bold left-aligned headline text at the top reads: STEP 2: HOLD
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: After breath 30,
exhale fully.
Hold on empty lungs.
Wait until the urge
to breathe arrives.
Then move to Step 3."

# Slide 5 — Step 3: Recovery Breath
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits upright taking a slow deep recovery inhale, one hand on chest, serene relieved expression, soft warm glow around him.
Large bold left-aligned headline text at the top reads: STEP 3: RECOVER
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Take one deep inhale.
Hold for 15 seconds.
Release fully.
That is one round.
Repeat 3 rounds total."

# Slide 6 — Safety Rules
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with one arm raised, palm out in a 'stop and listen' gesture, serious but caring expression — like a coach giving critical safety instructions.
Large bold left-aligned headline text at the top reads: SAFETY RULES
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: NEVER near water.
NEVER standing up.
Always on empty stomach.
Sit or lie down only.
For experienced
meditators only."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in a powerful upright meditation pose, both hands on knees, eyes open with a calm intense gaze — like someone who has just completed a Wim Hof round and feels transformed.
Large bold left-aligned headline text at the top reads: BREATHWORK'S
FINAL BOSS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Three rounds.
Done in 15 minutes.
Your body will feel
completely different.
At the bottom in bold text: Follow @stillmeditation for Day 74"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot sits in a powerful upright meditation pose, both hands on knees, eyes open with a calm intense gaze — like someone who has just completed a Wim Hof round and feels transformed.
Large bold left-aligned headline text at the top reads: BREATHWORK'S
FINAL BOSS.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Three rounds.
Done in 15 minutes.
Your body will feel
completely different.
At the bottom in bold text: Follow @stillmeditation.app for Day 74"

echo ""
echo "=== Day 73 Complete ==="
