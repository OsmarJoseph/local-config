#!/usr/bin/env bash
# Bootstrap herdr plugins. herdr has no declarative plugin list in config.toml,
# so this script is the reproducible, git-tracked record. Run once per machine:
#   bash ~/.config/herdr/install-plugins.sh
set -euo pipefail

PLUGDIR="$HOME/.local/share/herdr/plugins"
mkdir -p "$PLUGDIR"

# --- prerequisites (command palette needs fzf + jq; vim-herdr-navigation needs jq) ---
command -v fzf >/dev/null 2>&1 || brew install fzf
command -v jq  >/dev/null 2>&1 || brew install jq

clone_or_update() { # <git-url> <dest-dir>
  if [ -d "$2/.git" ]; then git -C "$2" pull --ff-only; else git clone "$1" "$2"; fi
}

# `herdr plugin link/install` talk to the API socket, so a server must be running.
# Start a throwaway headless one if needed and stop it again when done.
# Note: `herdr status server` exits 0 even when stopped, so probe the socket via
# `herdr api snapshot` (exits non-zero when no server is reachable).
started_server=0
if ! herdr api snapshot >/dev/null 2>&1; then
  herdr server >/dev/null 2>&1 &
  srv_pid=$!
  started_server=1
  for _ in $(seq 1 100); do
    herdr api snapshot >/dev/null 2>&1 && break
    kill -0 "$srv_pid" 2>/dev/null || break
  done
fi

have_plugin() { herdr plugin list 2>/dev/null | grep -q "^- $1 "; }

# --- pane navigation: vim-herdr-navigation (Ctrl+hjkl across nvim <-> herdr) ---
# Cloned + linked (not installed) so Neovim can dofile editor/nvim.lua from a stable path:
#   $PLUGDIR/vim-herdr-navigation/editor/nvim.lua
clone_or_update https://github.com/paulbkim-dev/vim-herdr-navigation "$PLUGDIR/vim-herdr-navigation"
have_plugin vim-herdr-navigation || herdr plugin link "$PLUGDIR/vim-herdr-navigation"

# --- fuzzy command palette over all plugin actions (prefix+p) ---
have_plugin jt.command-palette || herdr plugin install JanTvrdik/herdr-command-palette --yes

herdr server reload-config >/dev/null 2>&1 || true
if [ "$started_server" = 1 ]; then herdr server stop >/dev/null 2>&1 || true; fi
echo "herdr plugins bootstrapped into $PLUGDIR"
