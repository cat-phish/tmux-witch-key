#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux bind-key -T prefix L run -b "source $CURRENT_DIR/witch-key.sh"
