#!/usr/bin/env bash

CURRENT_DIR=""

show_window_menu() {
	tmux display-menu -T "Witch-Key - Windows" -x C -y S \
		"Next Window" "'" "next-window" \
		"Prev Window" "\;" "previous-window" \
		"Close Menu" Escape ""
}
