#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected_path=$1
else
selected_path=$(find ~ ~/Repos -mindepth 1 -maxdepth 5 -type d \( -path "$HOME/Library" -o -path "$HOME/.Trash" -o -path "*/node_modules" \) -prune -o -type d -print | fzf)
fi

if [[ -z $selected_path ]]; then
    exit 0
fi

last_tmux_session_number=$(tmux list-sessions | tail -1 |  awk '{print substr($1, 1, 1) + 1}')

folder_name+=$(basename "$selected_path" | tr . _)

session_name+=$last_tmux_session_number-$folder_name

tmux_running=$(pgrep tmux)

# if running out of tmux process
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $session_name -c $selected_path
    exit 0
fi

if tmux list-sessions | grep -q $folder_name; then
  session_name=$(tmux list-sessions | awk -F ':' '{print substr($1, 0)}' | grep $folder_name)
else
  tmux new-session -ds $session_name -c $selected_path
fi


tmux switch-client -t $session_name
