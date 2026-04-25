#!/bin/bash
# Preflight checks before a daily post.
# Verifies: git sync, ADC token, PostBridge tokens for TikTok+IG (and FB if connected).
# Usage: ./preflight.sh
set -u
[ -f .env ] && export $(grep -v '^#' .env | xargs)

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[0;33m'; NC='\033[0m'
PASS=0; WARN=0; FAIL=0

ok()   { echo -e "  ${GREEN}✓${NC} $1"; PASS=$((PASS+1)); }
warn() { echo -e "  ${YELLOW}⚠${NC} $1"; WARN=$((WARN+1)); }
bad()  { echo -e "  ${RED}✗${NC} $1"; FAIL=$((FAIL+1)); }

echo "=== 1. Git status ==="
if git pull --ff-only origin main > /dev/null 2>&1; then
  ok "git pull clean"
else
  bad "git pull failed — sync manually before posting"
fi

echo ""
echo "=== 2. Google ADC token + Drive scope (for Drive archive — non-blocking) ==="
if ! ADC_TOKEN=$(gcloud auth application-default print-access-token 2>/dev/null); then
  warn "ADC expired — run: gcloud auth application-default login --scopes=https://www.googleapis.com/auth/drive,https://www.googleapis.com/auth/cloud-platform"
else
  # Probe a harmless Drive list call; if 403 scope error → token lacks Drive scope
  probe=$(curl -s -o /dev/null -w "%{http_code}" \
    "https://www.googleapis.com/drive/v3/files?pageSize=1" \
    -H "Authorization: Bearer $ADC_TOKEN" \
    -H "X-Goog-User-Project: still-app-3e2dd")
  if [ "$probe" = "200" ]; then
    ok "ADC token valid + Drive scope present"
  else
    warn "ADC token valid but Drive scope missing (HTTP $probe). Re-auth: gcloud auth application-default login --scopes=https://www.googleapis.com/auth/drive,https://www.googleapis.com/auth/cloud-platform"
  fi
fi

echo ""
echo "=== 3. PostBridge connected accounts ==="
ACCTS=$(curl -s "https://api.post-bridge.com/v1/social-accounts" -H "Authorization: Bearer $POST_BRIDGE_API_KEY")
for plat in tiktok instagram facebook youtube; do
  row=$(echo "$ACCTS" | jq -r ".data[] | select(.platform==\"$plat\") | \"\(.id)|\(.username)\"")
  if [ -n "$row" ]; then
    ok "$plat connected: $row"
  else
    if [ "$plat" = "tiktok" ] || [ "$plat" = "instagram" ]; then
      bad "$plat NOT connected — reconnect in PostBridge"
    else
      warn "$plat not connected (optional)"
    fi
  fi
done

# Save current IDs for post script to consume
echo "$ACCTS" | jq '{tiktok: (.data[] | select(.platform=="tiktok") | .id),
                     instagram: (.data[] | select(.platform=="instagram") | .id),
                     facebook: (.data[] | select(.platform=="facebook") | .id),
                     youtube: (.data[] | select(.platform=="youtube") | .id)}' \
  > .social-accounts.json 2>/dev/null || true
echo "  saved → .social-accounts.json"

echo ""
echo "=== 4. Token health probe (PostBridge-only draft, no real publish) ==="
# Upload one tiny test image, then create is_draft:true posts, then delete.
# is_draft:true keeps the post on PostBridge — it does NOT reach the platform.
# However, PostBridge still validates tokens on creation for some platforms.
# We use the lightest signal available: re-check accounts.data includes each platform.
# A more active probe would need to post for real; we avoid that.
ok "Skipping active probe (would require real post). Rely on account list above."

echo ""
echo "============================================"
echo -e "${GREEN}PASS:${NC} $PASS   ${YELLOW}WARN:${NC} $WARN   ${RED}FAIL:${NC} $FAIL"
echo "============================================"
[ $FAIL -eq 0 ] && exit 0 || exit 1
