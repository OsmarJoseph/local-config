#!/usr/bin/env bash
# tmux-rename.sh — Set/remove an icon suffix on the current tmux window.
# Usage: tmux-rename.sh <state>   → look up icon for state (idle/processing/attention)
#        tmux-rename.sh           → strip suffix, re-enable automatic-rename

set -euo pipefail
[[ -z "${TMUX_PANE:-}" ]] && exit 0

# Skip renaming if the window belongs to nvim
WINDOW_NAME=$(tmux display-message -p -t "$TMUX_PANE" '#W')
[[ "$WINDOW_NAME" == *"nvim"* ]] && exit 0

# Resolve plugin root
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

# Use Claude's pane title (strip leading "* ") as the base name,
# falling back to current window name (strip icon suffix).
PANE_TITLE=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_title}')

if [[ -n "$PANE_TITLE" ]]; then
  CLEAN=$(printf '%s' "$PANE_TITLE" | sed 's/^[^a-zA-Z]*//')
else
  CURRENT=$(tmux display-message -p -t "$TMUX_PANE" '#W')
  CLEAN="${CURRENT% *}"
fi

if [[ $# -ge 1 ]]; then
  STATE="$1"

  # Resolve state name to icon via config
  CONF="${PLUGIN_ROOT}/config/active.conf"
  ICON=""
  if [[ -f "$CONF" ]]; then
    ICON=$(grep "^${STATE}=" "$CONF" 2>/dev/null | cut -d= -f2- || true)
  fi

  # Fallback to hardcoded defaults if config missing or state not found
  if [[ -z "$ICON" ]]; then
    case "$STATE" in
      idle)       ICON="😴" ;;
      processing) ICON="🧑‍🍳" ;;
      attention)  ICON="👀" ;;
      *)          ICON="$STATE" ;;  # pass through raw icons (backward compat)
    esac
  fi

  tmux rename-window -t "$TMUX_PANE" "${CLEAN} [${ICON}]"
else
  tmux rename-window -t "$TMUX_PANE" "$CLEAN"
  tmux set-window-option -t "$TMUX_PANE" automatic-rename on
fi
