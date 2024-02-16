#!/usr/bin/env bash

CURRENT_DIR="/home/jordan/coding/tmux-plugins/tmux-witch-key"

show_session_menu() {
    tmux display-menu -T "Witch-Key - Session" -x C -y S \
        "Detach" "d" 'detach-client' \
        "Refresh" "r" 'refresh-client' \
        "Close Menu" Escape ""
}

show_window_menu() {
    tmux display-menu -T "Witch-Key - Window" -x C -y S \
        "Next Window" "C-n" 'next-window' \
        "Prev Window" "C-p" 'previous-window' \
        "Split (V)" "-" 'split-window -v -c "#{pane_current_path}"' \
        "Split (H)" "\\" 'split-window -h -c "#{pane_current_path}"' \
        "Next Window" "n" 'next-window' \
        "Prev Window" "p" 'previous-window' \
        "Next Window" "M-n" 'next-window -a' \
        "Close Menu" Escape ""
}

show_pane_menu() {
    tmux display-menu -T "Witch-Key - Pane" -x C -y S \
        "Switch Down" "j" 'select-pane -D' \
        "Switch Up" "k" 'select-pane -U' \
        "Close Menu" Escape ""
}

