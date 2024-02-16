#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_KEYMAPS="$CURRENT_DIR/tmux-keymaps.txt"
WITCH_KEY_MENUS_SH="$CURRENT_DIR/witch-key-menus.sh"

# Write the output of the tmux list-keys command to a file
tmux list-keys >$TMUX_KEYMAPS

# Start building the new witch-key-menus.sh script
echo "#!/usr/bin/env bash" >$WITCH_KEY_MENUS_SH
echo "" >>$WITCH_KEY_MENUS_SH
echo "CURRENT_DIR=\"\$(cd \"\$(dirname \"\${BASH_SOURCE[0]}\")\" && pwd)\"" >>$WITCH_KEY_MENUS_SH
echo "" >>$WITCH_KEY_MENUS_SH

# Declare an array of the types of windows we want to create
declare -a window_types=("session" "window" "pane")

# Define the commands to look for and their corresponding titles for each window type
declare -a session_commands=("new-session -s" "switch-client -n" "switch-client -p" "switch-client -l" "kill-session" "detach-client" "refresh-client")
declare -A session_titles=(
	["new-session -s"]="New Session"
	["switch-client -n"]="Next Session"
	["switch-client -p"]="Prev Session"
	["switch-client -l"]="Last Session"
	["kill-session"]="Kill Session"
	["detach-client"]="Detach"
	["refresh-client"]="Refresh"
)

declare -a window_commands=("next-window" "previous-window" "next-window -a" "previous-window -a" "split-window -h" "split-window -v")
declare -A window_titles=(
	["next-window"]="Next Window"
	["previous-window"]="Prev Window"
	["next-window -a"]="Next (Alert)"
	["previous-window -a"]="Prev (Alert)"
	["split-window -h"]="Split (H)"
	["split-window -v"]="Split (V)"
)

declare -a pane_commands=("select-pane -U" "select-pane -D" "select-pane -L" "select-pane -R" "swap-pane -U" "swap-pane -D" "swap-pane -L" "swap-pane -R" "resize-pane -U" "resize-pane -D" "resize-pane -L" "resize-pane -R" "resize-pane -U 5" "resize-pane -D 5" "resize-pane -L 5" "resize-pane -R 5" "kill-pane" "last-pane")
declare -A pane_titles=(
	["select-pane -U"]="Switch Up"
	["select-pane -D"]="Switch Down"
	["select-pane -L"]="Switch Left"
	["select-pane -R"]="Switch Right"
	["swap-pane -U"]="Swap Up"
	["swap-pane -D"]="Swap Down"
	["swap-pane -L"]="Swap Left"
	["swap-pane -R"]="Swap Right"
	["resize-pane -U"]="Resize Up"
	["resize-pane -D"]="Resize Down"
	["resize-pane -L"]="Resize Left"
	["resize-pane -R"]="Resize Right"
	["resize-pane -U 5"]="Resize Up 5"
	["resize-pane -D 5"]="Resize Down 5"
	["resize-pane -L 5"]="Resize Left 5"
	["resize-pane -R 5"]="Resize Right 5"
	["kill-pane"]="Kill Pane"
	["last-pane"]="Last Pane"
)

# Store the tmux list-keys output in an array
mapfile -t tmux_keys <$TMUX_KEYMAPS

# Iterate over the types of windows we want to create
for window_type in "${window_types[@]}"; do
	# Get the commands and titles for the current window type
	declare -n commands="${window_type}_commands"
	declare -n titles="${window_type}_titles"

	echo "show_${window_type}_menu() {" >>$WITCH_KEY_MENUS_SH
	echo "    tmux display-menu -T \"Witch-Key - ${window_type^}\" -x C -y S \\" >>$WITCH_KEY_MENUS_SH

	# Add the main menu entry
	echo "        \"Main Menu\" \"BackSpace\" \"run -b 'source \\\"\$CURRENT_DIR/witch-key.sh\\\"'\" \\" >>$WITCH_KEY_MENUS_SH

	# Iterate over the commands we're looking for
	for key in "${commands[@]}"; do
		# Search for the corresponding line in the tmux list-keys output
		for line in "${tmux_keys[@]}"; do
			# Check if the line is a prefix key binding
			if [[ $line == *"-T prefix"* ]]; then
				# Extract the key binding from the line
				bind=$(echo $line | awk '{for(i=1;i<=NF;i++) if($i ~ /bind-key/) {print $(i+3); exit}}')
				# Extract the command from the line
				cmd=$(echo $line | awk '{for(i=1;i<=NF;i++) if($i ~ /bind-key/) {print substr($0, index($0,$(i+4))); exit}}')
				# If the key contains a space
				if [[ $key == *" "* ]]; then
					# Check if the command exactly matches the key or if the command starts with the key followed by a space
					if [[ $cmd == $key || $cmd =~ ^$key[[:space:]] ]]; then
						# Get the title for the command
						title=${titles[$key]}
						# Handle special cases for the key binding
						if [[ $bind == "\'" ]]; then
							bind="'"
						elif [[ $bind == "\"" ]]; then
							bind="\""
						fi
						# Write the menu item to the script
						echo "        \"$title\" \"$bind\" '$cmd' \\" >>$WITCH_KEY_MENUS_SH
					fi
				else
					# If the key doesn't contain a space, check if the command exactly matches the key
					if [[ $cmd == $key ]]; then
						# Get the title for the command
						title=${titles[$key]}
						# Handle special cases for the key binding
						if [[ $bind == "\'" ]]; then
							bind="'"
						elif [[ $bind == "\"" ]]; then
							bind="\""
						fi
						# Write the menu item to the script
						echo "        \"$title\" \"$bind\" '$cmd' \\" >>$WITCH_KEY_MENUS_SH
					fi
				fi
			fi
		done
	done

	# Add the close menu option
	echo "        \"Close Menu\" Escape \"\"" >>$WITCH_KEY_MENUS_SH
	echo "}" >>$WITCH_KEY_MENUS_SH
	echo "" >>$WITCH_KEY_MENUS_SH
done

# Make the new witch-key-menus.sh script executable
chmod u+x $WITCH_KEY_MENUS_SH

# Display a finished building message to the user
tmux display-message "Witch-Key menus have finished building"
