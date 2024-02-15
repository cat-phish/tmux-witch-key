#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux display-menu -T "Witch-Key" -x C -y S \
	"Session" s "run -b 'source \"$CURRENT_DIR/witch-key-menus.sh\" session'" \
	"Window" w "run -b 'source \"$CURRENT_DIR/witch-key-menus.sh\"; show_window_menu'" \
	"Pane" p "run -b 'source \"$CURRENT_DIR/witch-key-menus.sh\"; pane'" \
	"" \
	"Build Menu" B "run -b 'source \"$CURRENT_DIR/witch-key-build.sh\"'" \
	"Close Menu" Escape ""
