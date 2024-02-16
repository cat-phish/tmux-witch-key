#!/usr/bin/env bash

CURRENT_DIR="."

show_window_menu() {
    tmux display-menu -T "Witch-Key - Windows" -x C -y S \
        "Next Window" "C-n" 'next-window' \
        "Prev Window" "C-p" 'previous-window' \
        "Split (H)" "\\" 'split-window -h -c "#{pane_current_path}"' \
        "Next Window" "n" 'next-window' \
        "Prev Window" "p" 'previous-window' \
        "Next Window" "M-n" 'next-window -a' \
        "Close Menu" Escape ""
}
