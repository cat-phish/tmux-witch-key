#!/usr/bin/env bash

CURRENT_DIR="."

show_window_menu() {
	tmux display-menu -T "Witch-Key - Windows" -x C -y S \
		"Next Window" "'" 'next-window ' \
		"Split (H)" "\\" 'split-window -h -c "#{pane_current_path}"' \
		"Prev Window" "\;" 'previous-window ' \
		"Close Menu" Escape ""
}
