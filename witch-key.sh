#!/usr/bin/env bash
#
# Use dash because of its fast startup time.
#
#
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux display-menu -T "My Prefix Mappings" -x C -y L \
	"B: Build Menu" "run-shell $CURRENT_DIR/witch-key-build.sh'" \
	"1: Command 1" "send-keys 'Command1'" \
	"2: Command 2" "send-keys 'Command2'"
