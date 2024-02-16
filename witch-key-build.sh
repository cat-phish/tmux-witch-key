#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_KEYMAPS="$CURRENT_DIR/tmux-keymaps.txt"
WITCH_KEY_MENUS_SH="$CURRENT_DIR/witch-key-menus.sh"

# Write the output of the tmux list-keys command to a file
tmux list-keys >$TMUX_KEYMAPS

# Start building the new witch-key-menus.sh script
echo "#!/usr/bin/env bash" >$WITCH_KEY_MENUS_SH
echo "" >>$WITCH_KEY_MENUS_SH
echo "CURRENT_DIR=\"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)\"" >>$WITCH_KEY_MENUS_SH
echo "" >>$WITCH_KEY_MENUS_SH

# Declare an array of the types of windows we want to create
declare -a window_types=("session" "window" "pane")

# Define the commands to look for and their corresponding titles for each window type
declare -A session_commands
session_commands=(["detach-client"]="Detach" ["refresh-client"]="Refresh")

declare -A window_commands
window_commands=(["next-window"]="Next Window" ["previous-window"]="Prev Window" ["split-window -h"]="Split (H)" ["split-window -v"]="Split (V)")

declare -A pane_commands
pane_commands=(["select-pane -U"]="Switch Up" ["select-pane -D"]="Switch Down")

# Iterate over the types of windows we want to create
for window_type in "${window_types[@]}"; do
	# Get the commands for the current window type
	declare -n commands="${window_type}_commands"

	echo "show_${window_type}_menu() {" >>$WITCH_KEY_MENUS_SH
	echo "    tmux display-menu -T \"Witch-Key - ${window_type^}\" -x C -y S \\" >>$WITCH_KEY_MENUS_SH

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
	echo "" >>$WITCH_KEY_MENUS_SH
done

# Make the new witch-key-menus.sh script executable
chmod +x $WITCH_KEY_MENUS_SH
