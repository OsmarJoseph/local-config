#!/usr/bin/env bash

# Kanagawa colors for Tmux

set -g mode-style "fg=#93b5d0,bg=#2a2a37"

set -g message-style "fg=#93b5d0,bg=#2a2a37"
set -g message-command-style "fg=#93b5d0,bg=#2a2a37"

set -g pane-border-style "fg=#2a2a37"
set -g pane-active-border-style "fg=#93b5d0"

set -g status "on"
set -g status-justify "left"

set -g status-style "fg=#93b5d0,bg=#1f1f28"

set -g status-left-length "100"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

set -g status-left "#[fg=#1f1f28,bg=#93b5d0,bold] #S #[fg=#93b5d0,bg=#1f1f28,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=#1f1f28,bg=#1f1f28,nobold,nounderscore,noitalics]#[fg=#93b5d0,bg=#1f1f28] #{prefix_highlight} #[fg=#2a2a37,bg=#1f1f28,nobold,nounderscore,noitalics]#[fg=#93b5d0,bg=#2a2a37] %Y-%m-%d  %H:%M #[fg=#93b5d0,bg=#2a2a37,nobold,nounderscore,noitalics]"

setw -g window-status-activity-style "underscore,fg=#c34043,bg=#1f1f28"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=#c8c093,bg=#1f1f28"
setw -g window-status-format "#[fg=#1f1f28,bg=#1f1f28,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#1f1f28,bg=#1f1f28,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=#1f1f28,bg=#2a2a37,nobold,nounderscore,noitalics]#[fg=#93b5d0,bg=#2a2a37,bold] #I  #W #F #[fg=#2a2a37,bg=#1f1f28,nobold,nounderscore,noitalics]"

# tmux-plugins/tmux-prefix-highlight support
set -g @prefix_highlight_output_prefix "#[fg=#e6c384]#[bg=#1f1f28]#[fg=#1f1f28]#[bg=#e6c384]"
set -g @prefix_highlight_output_suffix ""
