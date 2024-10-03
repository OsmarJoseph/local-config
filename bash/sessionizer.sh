#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
selected=$(find ~ ~/Repos -mindepth 1 -maxdepth 5 -type d \( -path "$HOME/Library" -o -path "$HOME/.Trash" -o -path "*/node_modules" \) -prune -o -type d -print | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

folder_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $folder_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$folder_name 2> /dev/null; then
    tmux new-session -ds $folder_name -c $selected
fi

tmux switch-client -t $folder_name
