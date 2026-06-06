#!/bin/bash
# Generate Day 66 slides: "Meditation on emotions: the R.A.I.N. technique" — TUTORIAL
[ -f .env ] && export $(grep -v '^#' .env | xargs)

API_KEY="${GEMINI_API_KEY}"
MODEL="gemini-3.1-flash-image-preview"
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent"
OUTPUT_DIR="slides/day66"

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
The scene: The mascot sits cross-legged in a calm meditation pose, eyes soft and open, one hand raised gently with fingers spread — suggesting a moment of pause and presence in the middle of emotional turbulence. Warm light surrounds them.
Large bold left-aligned headline text at the top reads: NEXT TIME A STRONG
EMOTION HITS,
TRY R.A.I.N.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: A 4-step technique from
meditation teacher Tara Brach.
Stop reacting.
Start seeing clearly."

# Slide 2 — R: Recognize
generate_slide 2 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60% of the card. The mascot is on the FAR RIGHT, fully inside the right 40%, with NOTHING in the left text zone.
The scene: The mascot points a finger to the side of their head with a calm, aware expression — the look of someone noticing something clearly for the first time.
Large bold left-aligned ALL-CAPS headline text at the top reads: R — RECOGNIZE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Name what you are feeling.
'I notice I am angry.'
'I notice I am afraid.'
That single step breaks the loop."

# Slide 3 — A: Allow
generate_slide 3 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot sits with hands open on their knees, palms up, in a posture of open acceptance — relaxed, not fighting anything, just present.
Large bold left-aligned ALL-CAPS headline text at the top reads: A — ALLOW
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Let the emotion be there.
Don't fight it. Don't fix it.
Just let it exist.
Resistance feeds the flame."

# Slide 4 — I: Investigate
generate_slide 4 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot places one hand gently on their chest with a curious, kind expression — looking inward, exploring the body with care rather than fear.
Large bold left-aligned ALL-CAPS headline text at the top reads: I — INVESTIGATE
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Where do you feel it
in your body?
Tight chest? Clenched jaw?
Explore it with curiosity,
not judgement."

# Slide 5 — N: Non-Identification
generate_slide 5 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands with arms slightly open, a calm expression of freedom and spaciousness — like someone who has just set down a heavy weight and can breathe again.
Large bold left-aligned ALL-CAPS headline text at the top reads: N — NON-IDENTIFICATION
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: This emotion is visiting you.
It is not you.
'I am angry' locks it in.
'I notice anger' sets it free."

# Slide 6 — How to Use It
generate_slide 6 "Create a bold TikTok social media card illustration. ${STYLE}
Layout: Text occupies the LEFT 60%. Mascot on the FAR RIGHT, nothing in the left text zone.
The scene: The mascot stands in a confident teaching pose with one hand raised, as if guiding someone through the steps — calm, clear, instructive.
Large bold left-aligned ALL-CAPS headline text at the top reads: HOW TO USE IT
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: When a strong emotion rises:
→ R: Name it without judgement.
→ A: Let it be there.
→ I: Find it in your body.
→ N: You are bigger than this feeling."

# Slide 7 — CTA (TikTok variant)
generate_slide 7 "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with a calm, open-hearted expression — hands at their sides, chest open, a quiet strength in their posture. Warm light fills the meditation room.
Large bold left-aligned headline text at the top reads: R.A.I.N.
YOUR EMOTIONAL
RESET BUTTON.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Feelings don't disappear when ignored.
But when you shine a light on them,
they lose their grip.
At the bottom in bold text: Follow @stillmeditation for Day 67"

# Slide 7 — IG variant (different handle)
generate_slide 7_instagram "Create a bold TikTok social media card illustration. ${STYLE}
The scene: The mascot stands tall with a calm, open-hearted expression — hands at their sides, chest open, a quiet strength in their posture. Warm light fills the meditation room.
Large bold left-aligned headline text at the top reads: R.A.I.N.
YOUR EMOTIONAL
RESET BUTTON.
LEAVE A CLEAR GAP between headline and body.
Below in medium bold text: Feelings don't disappear when ignored.
But when you shine a light on them,
they lose their grip.
At the bottom in bold text: Follow @stillmeditation.app for Day 67"

echo ""
echo "=== Day 66 Complete ==="
