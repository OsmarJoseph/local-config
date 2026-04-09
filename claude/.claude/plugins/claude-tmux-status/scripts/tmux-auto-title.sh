#!/usr/bin/env bash
# tmux-auto-title.sh — On first prompt, auto-title the tmux window from the user's message.
# Called by the UserPromptSubmit hook. Delegates to tmux-rename.sh for icon handling.

# Read stdin (with 1s timeout to avoid hanging during plugin validation).
INPUT=""
if read -t 1 -r INPUT_LINE; then
  INPUT="$INPUT_LINE"
  while read -t 0.1 -r INPUT_LINE; do
    INPUT="${INPUT}${INPUT_LINE}"
  done
fi

[[ -z "${TMUX_PANE:-}" ]] && exit 0

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
DONE="/tmp/cc-titled-${PPID}"

# Only auto-title on the first prompt.
if [[ ! -f "$DONE" && -n "$INPUT" ]]; then
  PROMPT=""
  if command -v jq &>/dev/null; then
    PROMPT=$(printf '%s' "$INPUT" | jq -r '.prompt // empty' 2>/dev/null || true)
  else
    PROMPT=$(printf '%s' "$INPUT" \
      | grep -o '"prompt" *: *"[^"]*"' 2>/dev/null \
      | sed 's/.*: *"//;s/"$//' || true)
  fi

  if [[ -n "$PROMPT" ]]; then
    PROMPT="${PROMPT:0:30}"
    PROMPT=$(printf '%s' "$PROMPT" | tr -c '[:alnum:]' '-' | sed 's/-*$//')
    printf '%s' "$PROMPT" > "$DONE"
  fi
fi

exec "$PLUGIN_ROOT/scripts/tmux-rename.sh" processing
