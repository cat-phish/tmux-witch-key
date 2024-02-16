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

# NOTE: for mapping commands. if the command should be mapped exactly do not include a space in the key, if the command has
# possible arguments, include a space in the key and the command will be matched if it starts with the key followed by a space

# Define the commands to look for and their corresponding titles for each window type
declare -a session_commands=("new-session" "switch-client -n" "switch-client -p" "switch-client -l" "rename-session" "show-messages" "suspend-client" "lock-client" "kill-server" "kill-session" "kill-session -a" "list-sessions" "detach-client" "refresh-client")
declare -A session_titles=(
	["new-session"]="New Session"
	["switch-client -n"]="Next Session"
	["switch-client -p"]="Prev Session"
	["switch-client -l"]="Last Session"
	["rename-session"]="Rename Session"
	["show-messages"]="Show Messages"
	["suspend-client"]="Suspend Client"
	["lock-client"]="Lock Client"
	["kill-server"]="Kill Server"
	["kill-session"]="Kill Session"
	["kill-session -a"]="Kill All Other Sessions"
	["list-sessions"]="List Sessions"
	["detach-client"]="Detach"
	["refresh-client"]="Refresh"
)

declare -a window_commands=("next-window" "previous-window" "next-window -a" "previous-window -a" "split-window -h" "split-window -v" "split-window -fh" "split-window -fv" "swap window -d -t -1" "swap window -d -t +1" "rotate-window" "rotate-window -D" "rotate-window -U" "rotate window -DZ" "rotate window -UZ" "new-window" "new-window -c" "rename-window" "list-windows" "respawn-window" "even-horizontal" "even-vertical" "main-horizontal" "main-vertical" "tiled")
declare -A window_titles=(
	["next-window"]="Next Window"
	["previous-window"]="Prev Window"
	["next-window -a"]="Next (Alert)"
	["previous-window -a"]="Prev (Alert)"
	["split-window -h"]="Split (H)"
	["split-window -v"]="Split (V)"
	["split-window -fh"]="Split (Full H)"
	["split-window -fv"]="Split (Full V)"
	["swap window -d -t -1"]="Move Window (Left)"
	["swap window -d -t +1"]="Move Window (Right)"
	["rotate-window"]="Rotate Window"
	["rotate-window -D"]="Rotate Window Down"
	["rotate-window -U"]="Rotate Window Up"
	["rotate window -DZ"]="Rotate Window Down (Keep Zoom)"
	["rotate window -UZ"]="Rotate Window Up (Keep Zoom)"
	["new-window"]="New Window"
	["new-window -c"]="New Window (Current Dir)"
	["rename-window"]="Rename Window"
	["list-windows"]="List Windows"
	["respawn-window"]="Respawn Window"
	["even-horizontal"]="Even Horizontal Layout"
	["even-vertical"]="Even Vertical Layout"
	["main-horizontal"]="Main Horizontal Layout"
	["main-vertical"]="Main Vertical Layout"
	["tiled"]="Tiled Layout"
)

declare -a pane_commands=("select-pane -U" "select-pane -D" "select-pane -L" "select-pane -R" "select-pane -UZ" "select-pane -DZ" "select-pane -LZ" "select-pane -RZ" "swap-pane -U" "swap-pane -D" "swap-pane -L" "swap-pane -R" "resize-pane -U" "resize-pane -D" "resize-pane -L" "resize-pane -R" "resize-pane -U 5" "resize-pane -D 5" "resize-pane -L 5" "resize-pane -R 5" "respawn-pane" "kill-pane" "last-pane" "break-pane" "break-pane -d")
declare -A pane_titles=(
	["select-pane -U"]="Switch Up"
	["select-pane -D"]="Switch Down"
	["select-pane -L"]="Switch Left"
	["select-pane -R"]="Switch Right"
	["select-pane -UZ"]="Switch Up (Keep Zoom)"
	["select-pane -DZ"]="Switch Down (Keep Zoom)"
	["select-pane -LZ"]="Switch Left (Keep Zoom)"
	["select-pane -RZ"]="Switch Right (Keep Zoom)"
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
	["respawn-pane"]="Respawn Pane"
	["kill-pane"]="Kill Pane"
	["last-pane"]="Last Pane"
	["break-pane"]="Break Pane"
	["break-pane -d"]="Break Pane (Detached)"
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
						elif [[ $bind == "\\{" ]]; then
							bind="{"
						elif [[ $bind == "\\}" ]]; then
							bind="}"
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
						elif [[ $bind == "\\{" ]]; then
							bind="{"
						elif [[ $bind == "\\}" ]]; then
							bind="}"
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

# Display a message to the user
tmux display-message "Witch-Key menus have finished building!"
