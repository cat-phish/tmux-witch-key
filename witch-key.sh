#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_menu_session() {
   tmux display-menu -T "Witch-Key Session" -x C -y S \
      "" \
      "Build Menu" B "run -b 'source \"$CURRENT_DIR/witch-key-build.sh\"'" \
      "Close Menu" Escape ""
}
