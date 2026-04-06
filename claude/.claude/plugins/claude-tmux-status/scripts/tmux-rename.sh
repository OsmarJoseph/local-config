#!/usr/bin/env bash
# tmux-rename.sh — Set tmux window name to Claude session name with status icon.
# Usage: tmux-rename.sh [--resolve] <state>  → rename to "<session_name> [<icon>]"
#        tmux-rename.sh                      → clear session cache, re-enable automatic-rename

set -euo pipefail
[[ -z "${TMUX_PANE:-}" ]] && exit 0

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

# ---------------------------------------------------------------------------
# Parse --resolve flag (triggers session name re-read from disk)
# ---------------------------------------------------------------------------
RESOLVE=false
if [[ "${1:-}" == "--resolve" ]]; then
  RESOLVE=true
  shift
fi

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

if $RESOLVE; then
  SESSION_NAME=$(extract_session_name)
  if [[ -n "$SESSION_NAME" ]]; then
    tmux set-option -p -t "$TMUX_PANE" @claude_session "$SESSION_NAME"
  else
    tmux set-option -p -t "$TMUX_PANE" -u @claude_session 2>/dev/null || true
  fi
fi

# ---------------------------------------------------------------------------
# Determine base window name
# ---------------------------------------------------------------------------
CACHED=$(tmux display-message -p -t "$TMUX_PANE" '#{@claude_session}' 2>/dev/null)

if [[ -n "$CACHED" ]]; then
  BASE_NAME="$CACHED"
else
  # No session name — preserve the existing window name (strip icon suffix)
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
  # SessionEnd — clear cache, restore automatic naming
  tmux set-option -p -t "$TMUX_PANE" -u @claude_session 2>/dev/null || true
  tmux rename-window -t "$TMUX_PANE" "$BASE_NAME"
  tmux set-window-option -t "$TMUX_PANE" automatic-rename on
fi
