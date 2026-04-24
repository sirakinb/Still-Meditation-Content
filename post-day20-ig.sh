#!/bin/bash
# Post Day 20 to Instagram only (publishes live immediately)
set -e
[ -f .env ] && export $(grep -v '^#' .env | xargs)

PB_KEY="${POST_BRIDGE_API_KEY}"
PB_URL="https://api.post-bridge.com"
DAY=20
SLIDES_DIR="slides/day${DAY}"
CAPTION_FILE="captions/day${DAY}_caption.md"
INSTAGRAM_ACCOUNT=57667

IG_CAPTION=$(python3 -c "
import re
text = open('$CAPTION_FILE').read()
ig = re.search(r'## Instagram.*?\n(.*)', text, re.DOTALL).group(1).strip()
print(ig)
")

echo "=== IG caption (first 100 chars): ${IG_CAPTION:0:100}..."

upload_media() {
  local file=$1
  local name=$2
  local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
  local resp=$(curl -s -X POST "$PB_URL/v1/media/create-upload-url" \
    -H "Authorization: Bearer $PB_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"mime_type\":\"image/png\",\"size_bytes\":$size,\"name\":\"$name\"}")
  local mid=$(echo "$resp" | jq -r '.media_id')
  local url=$(echo "$resp" | jq -r '.upload_url')
  if [ -z "$mid" ] || [ "$mid" = "null" ]; then
    echo "ERROR creating upload url for $name: $resp" >&2
    return 1
  fi
  curl -s -X PUT "$url" -H "Content-Type: image/png" --data-binary @"$file" > /dev/null
  echo "$mid"
}

echo ""
echo "=== Uploading slides 1-6 ==="
MEDIA_IDS=()
for i in 1 2 3 4 5 6; do
  mid=$(upload_media "$SLIDES_DIR/slide${i}.png" "day${DAY}_slide${i}.png")
  echo "slide${i}: $mid"
  MEDIA_IDS+=("$mid")
done

echo ""
echo "=== Uploading slide 7_instagram ==="
MID_IG7=$(upload_media "$SLIDES_DIR/slide7_instagram.png" "day${DAY}_slide7_instagram.png")
echo "slide7 Instagram: $MID_IG7"

IG_MEDIA=$(printf '"%s",' "${MEDIA_IDS[@]}")
IG_MEDIA="[${IG_MEDIA}\"${MID_IG7}\"]"

echo ""
echo "=== Creating Instagram straight post ==="
IG_PAYLOAD=$(jq -n \
  --arg caption "$IG_CAPTION" \
  --argjson media "$IG_MEDIA" \
  --argjson acct "$INSTAGRAM_ACCOUNT" \
  '{
    caption: $caption,
    media: $media,
    social_accounts: [$acct]
  }')
IG_RESP=$(curl -s -X POST "$PB_URL/v1/posts" \
  -H "Authorization: Bearer $PB_KEY" \
  -H "Content-Type: application/json" \
  -d "$IG_PAYLOAD")
echo "Instagram response:"
echo "$IG_RESP" | jq '.'

echo ""
echo "=== Day ${DAY} Instagram post complete ==="
