#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_window_menu() {
	tmux display-menu -T "Witch-Key - Windows" -x C -y S \
		"Next Window" \' "next-window" \
		"Prev Window" \; "previous-window" \
		"Close Menu" Escape ""
}
