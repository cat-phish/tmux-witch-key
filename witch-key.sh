#!/usr/bin/env bash
#
# Use dash because of its fast startup time.
#
#
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux display-menu -T "Witch-Key" -x C -y S \
	"" \
	"Build Menu" B "run -b 'source \"$CURRENT_DIR/witch-key-build.sh\"'" \
	"Close Menu" Esc ""
