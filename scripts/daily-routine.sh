#!/bin/bash
# Still Meditation daily content routine.
# Runs at 7am ET daily via launchd (see ~/Library/LaunchAgents/com.stillmeditation.dailyroutine.plist).
# Invokes Claude Code headless with the prompt in scripts/daily-routine-prompt.md.

set -euo pipefail

REPO="/Users/sirakinb/Still-Meditation-Content"
PROMPT_FILE="${REPO}/scripts/daily-routine-prompt.md"
LOG_DIR="${REPO}/scripts/logs"
DATE=$(date +%Y-%m-%d)
LOG_FILE="${LOG_DIR}/${DATE}.log"

# Ensure log dir exists
mkdir -p "${LOG_DIR}"

# Make sure node/npm/claude are on PATH for launchd (launchd starts with a minimal env)
export PATH="/Users/sirakinb/.npm-global/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

# claude CLI absolute path — survives PATH issues
CLAUDE_BIN="/Users/sirakinb/.npm-global/bin/claude"

if [ ! -x "${CLAUDE_BIN}" ]; then
  echo "[$(date)] ERROR: claude CLI not found at ${CLAUDE_BIN}" >> "${LOG_FILE}"
  exit 1
fi

if [ ! -f "${PROMPT_FILE}" ]; then
  echo "[$(date)] ERROR: prompt file missing at ${PROMPT_FILE}" >> "${LOG_FILE}"
  exit 1
fi

cd "${REPO}"

{
  echo "=================================================================="
  echo "Still Meditation daily routine starting at $(date)"
  echo "Repo: ${REPO}"
  echo "Branch: $(git branch --show-current 2>/dev/null || echo 'unknown')"
  echo "=================================================================="
} >> "${LOG_FILE}"

# Run Claude Code headless.
#   -p                              : non-interactive
#   --dangerously-skip-permissions  : autonomous tool use (no permission prompts)
#   --model sonnet                  : capable, cost-reasonable
#   --max-budget-usd 5              : hard cap per run (~10x typical cost)
#   --add-dir REPO                  : already cwd, but be explicit
"${CLAUDE_BIN}" \
  -p \
  --dangerously-skip-permissions \
  --model sonnet \
  --max-budget-usd 5 \
  --add-dir "${REPO}" \
  "$(cat "${PROMPT_FILE}")" \
  >> "${LOG_FILE}" 2>&1 \
  || echo "[$(date)] Claude exited with non-zero status $?" >> "${LOG_FILE}"

{
  echo ""
  echo "=================================================================="
  echo "Daily routine finished at $(date)"
  echo "=================================================================="
  echo ""
} >> "${LOG_FILE}"

# Keep only the last 60 days of logs
find "${LOG_DIR}" -name '*.log' -mtime +60 -delete 2>/dev/null || true
