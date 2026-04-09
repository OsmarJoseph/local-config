#!/usr/bin/env bash
# tmux-rename.sh — Set tmux window name to Claude session name with status icon.
# Usage: tmux-rename.sh <state>  → rename to "<session_name> [<icon>]"
#        tmux-rename.sh          → clean up and re-enable automatic-rename

set -euo pipefail
[[ -z "${TMUX_PANE:-}" ]] && exit 0

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

# ---------------------------------------------------------------------------
# Session name resolution
# ---------------------------------------------------------------------------
extract_session_name() {
  local session_file="$HOME/.claude/sessions/${PPID}.json"
  [[ -f "$session_file" ]] || return

  if command -v jq &>/dev/null; then
    jq -r '.name // empty' "$session_file" 2>/dev/null
  else
    grep -o '"name" *: *"[^"]*"' "$session_file" 2>/dev/null \
      | sed 's/.*: *"//;s/"$//' || true
  fi
}

SESSION_NAME=$(extract_session_name)
TITLE_FILE="/tmp/cc-titled-${PPID}"

if [[ -n "$SESSION_NAME" ]]; then
  BASE_NAME="$SESSION_NAME"
elif [[ -f "$TITLE_FILE" ]]; then
  BASE_NAME=$(cat "$TITLE_FILE")
else
  # No session name, no auto-title — preserve the existing window name (strip icon suffix)
  CURRENT=$(tmux display-message -p -t "$TMUX_PANE" '#W')
  BASE_NAME="${CURRENT% \[*\]}"
fi

# ---------------------------------------------------------------------------
# Apply state icon or clean up
# ---------------------------------------------------------------------------
if [[ $# -ge 1 ]]; then
  STATE="$1"

  # Resolve state → icon via config
  CONF="${PLUGIN_ROOT}/config/active.conf"
  ICON=""
  if [[ -f "$CONF" ]]; then
    ICON=$(grep "^${STATE}=" "$CONF" 2>/dev/null | cut -d= -f2- || true)
  fi

  # Fallback to hardcoded defaults
  if [[ -z "$ICON" ]]; then
    case "$STATE" in
      idle)       ICON="😴" ;;
      processing) ICON="🧑‍🍳" ;;
      attention)  ICON="👀" ;;
      *)          ICON="$STATE" ;;
    esac
  fi

  tmux rename-window -t "$TMUX_PANE" "${BASE_NAME} [${ICON}]"
else
  # SessionEnd — restore automatic naming
  tmux rename-window -t "$TMUX_PANE" "$BASE_NAME"
  tmux set-window-option -t "$TMUX_PANE" automatic-rename on
fi
