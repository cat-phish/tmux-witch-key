#!/usr/bin/env bash

CURRENT_DIR="$(dirname "${BASH_SOURCE[0]}")"
#!/usr/bin/env bash

CURRENT_DIR="$(dirname "${BASH_SOURCE[0]}")"
TMUX_KEYMAPS="$CURRENT_DIR/tmux-keymaps.txt"
WITCH_KEY_MENUS_SH="$CURRENT_DIR/witch-key-menus.sh"

# Write the output of the tmux list-keys command to a file
tmux list-keys >$TMUX_KEYMAPS

# Start building the new witch-key-menus.sh script
echo "#!/usr/bin/env bash" >$WITCH_KEY_MENUS_SH
echo "" >>$WITCH_KEY_MENUS_SH
echo "CURRENT_DIR=\"$CURRENT_DIR\"" >>$WITCH_KEY_MENUS_SH
echo "" >>$WITCH_KEY_MENUS_SH
echo "show_window_menu() {" >>$WITCH_KEY_MENUS_SH
echo "    tmux display-menu -T \"Witch-Key - Windows\" -x C -y S \\" >>$WITCH_KEY_MENUS_SH

# Define the commands to look for and their corresponding titles
declare -A commands
commands=(["next-window"]="Next Window" ["previous-window"]="Prev Window" ["split-window -h"]="Split (H)")

# Parse the tmux-keymaps.txt file
while IFS= read -r line; do
	if [[ $line == *"-T prefix"* ]]; then
		bind=$(echo $line | awk '{print $5}')
		for key in "${!commands[@]}"; do
			if [[ $line == *"$key"* ]]; then
				title=${commands[$key]}
				if [[ $bind == "\'" ]]; then
					bind="'"
				elif [[ $bind == "\"" ]]; then
					bind="\""
				fi
				cmd=$(echo $line | awk -v key="$key" '$0 ~ key {for(i=6;i<=NF;i++) printf $i" "; print ""}')
				if [[ $cmd == $key* ]]; then
					echo "        \"$title\" \"$bind\" '$cmd' \\" >>$WITCH_KEY_MENUS_SH
				fi
			fi
		done
	fi
done <$TMUX_KEYMAPS

# Add the close menu option
echo "        \"Close Menu\" Escape \"\"" >>$WITCH_KEY_MENUS_SH
echo "}" >>$WITCH_KEY_MENUS_SH

# Make the new witch-key-menus.sh script executable
chmod +x $WITCH_KEY_MENUS_SH
