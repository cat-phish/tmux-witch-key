#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_CONF="$HOME/.tmux.conf"
WITCH_KEY_SH="$CURRENT_DIR/witch-key.sh"

# Start building the new witch-key.sh script
echo "#!/usr/bin/env bash" >$WITCH_KEY_SH
echo "" >>$WITCH_KEY_SH
echo "CURRENT_DIR=\"$(cd \"$(dirname \"\${BASH_SOURCE[0]}\")\" && pwd)\"" >>$WITCH_KEY_SH
echo "" >>$WITCH_KEY_SH
echo "tmux display-menu -T \"Witch-Key\" -x C -y L \\" >>$WITCH_KEY_SH

# Parse the tmux.conf file
prev_line=""
while IFS= read -r line; do
	if [[ $prev_line == *"#@witch-key add-custom"* ]]; then
		desc=$(echo $prev_line | sed -n 's/.*desc="\([^"]*\)".*/\1/p')
		bind=$(echo $prev_line | sed -n 's/.*bind="\([^"]*\)".*/\1/p')
		cmd=$(echo $prev_line | sed -n 's/.*cmd="\([^"]*\)".*/\1/p')
		echo "\"$bind: $desc\" \"send-keys '$cmd'\" \\" >>$WITCH_KEY_SH
	elif [[ $prev_line == *"#@witch-key add"* ]]; then
		bind=$(echo $line | awk "{print $2}")
		cmd=$(echo $line | cut -d' ' -f3-)
		echo "\"$bind: $desc\" \"send-keys '$cmd'\" \\" >>$WITCH_KEY_SH
	elif [[ $prev_line == *"#@witch-key end-group"* ]]; then
		echo "\"-: ----------------\" \"\" \\" >>$WITCH_KEY_SH
	fi
	prev_line=$line
done <$TMUX_CONF

# Add the default menu item
echo "\"B: Build Menu\" \"run-shell '\$CURRENT_DIR/witch-key-build.sh'\"" >>$WITCH_KEY_SH

# Make the new witch-key.sh script executable
chmod +x $WITCH_KEY_SH
