#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux display-menu -T "Witch-Key" -x C -y S \
	"Session" s "run -b 'source \"$CURRENT_DIR/witch-key.sh && show_session)menu\"'" \
	"Window" w "run -b 'source \"$CURRENT_DIR/witch-key.sh && show_session)menu\"'" \
	"Pane" p "run -b 'source \"$CURRENT_DIR/witch-key.sh && show_session)menu\"'" \
	"" \
	"Build Menu" B "run -b 'source \"$CURRENT_DIR/witch-key-build.sh\"'" \
	"Close Menu" Escape ""

#tmux bind-key -T prefix L run -b "source $CURRENT_DIR/witch-key.sh"
