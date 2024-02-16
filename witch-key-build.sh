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
	# Check if the line is a prefix key binding
	if [[ $line == *"-T prefix"* ]]; then
		# Extract the key binding from the line
		bind=$(echo $line | awk '{for(i=1;i<=NF;i++) if($i ~ /bind-key/) {print $(i+3); exit}}')
		# Extract the command from the line
		cmd=$(echo $line | awk '{for(i=1;i<=NF;i++) if($i ~ /bind-key/) {print substr($0, index($0,$(i+4))); exit}}')
		# Iterate over the commands we're looking for
		for key in "${!commands[@]}"; do
			# Check if the command starts with the key
			if [[ $cmd == $key* ]]; then
				# Get the title for the command
				title=${commands[$key]}
				# Handle special cases for the key binding
				if [[ $bind == "\'" ]]; then
					bind="'"
				elif [[ $bind == "\"" ]]; then
					bind="\""
				fi
				# Write the menu item to the script
				echo "        \"$title\" \"$bind\" '$cmd' \\" >>$WITCH_KEY_MENUS_SH
			fi
		done
	fi
done <$TMUX_KEYMAPS

# Add the close menu option
echo "        \"Close Menu\" Escape \"\"" >>$WITCH_KEY_MENUS_SH
echo "}" >>$WITCH_KEY_MENUS_SH

# Make the new witch-key-menus.sh script executable
chmod +x $WITCH_KEY_MENUS_SH
