#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux display-menu -T "Witch-Key" -x C -y S \
	"Session" s "run -b 'source \"$CURRENT_DIR/witch-key-menus.sh\"; show_session_menu'" \
	"Window" w "run -b 'source \"$CURRENT_DIR/witch-key-menus.sh\"; show_window_menu'" \
	"Pane" p "run -b 'source \"$CURRENT_DIR/witch-key-menus.sh\"; show_pane_menu'" \
	"" \
	"Build Menu" B "run -b 'source \"$CURRENT_DIR/witch-key-build.sh\"'" \
	"Close Menu" Escape ""
# "Test Command" t "run -b 'source \"$CURRENT_DIR/witch-key-menus.sh\"; show_test_menu'"
