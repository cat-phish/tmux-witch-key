#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_KEYMAPS="$CURRENT_DIR/tmux-keymaps.txt"
WITCH_KEY_MENUS_SH="$CURRENT_DIR/witch-key-menus.sh"

# Write the output of the tmux list-keys command to a file
tmux list-keys >$TMUX_KEYMAPS

# Start building the new witch-key-menus.sh script
echo "#!/usr/bin/env bash" >$WITCH_KEY_MENUS_SH
echo "" >>$WITCH_KEY_MENUS_SH
echo "CURRENT_DIR=\"$(cd \"$(dirname \"\${BASH_SOURCE[0]}\")\" && pwd)\"" >>$WITCH_KEY_MENUS_SH
echo "" >>$WITCH_KEY_MENUS_SH
echo "show_window_menu() {" >>$WITCH_KEY_MENUS_SH
echo "    tmux display-menu -T \"Witch-Key - Windows\" -x C -y S \\" >>$WITCH_KEY_MENUS_SH

# Define the commands to look for and their corresponding titles
declare -A commands
commands=(["next-window"]="Next Window" ["previous-window"]="Prev Window")

# Parse the tmux-keymaps.txt file
while IFS= read -r line; do
	if [[ $line == *"-T prefix"* ]]; then
		bind=$(echo $line | awk '{print $5}')
		cmd=$(echo $line | awk '{print $6}')
		if [[ ${commands[$cmd]} ]]; then
			title=${commands[$cmd]}
			if [[ $bind == "\'" ]]; then
				bind="'"
			elif [[ $bind == "\"" ]]; then
				bind="\""
			fi
			if [[ $line == *"-r"* ]]; then
				echo "        \"$title\" \"$bind\" \"$cmd\" \\" >>$WITCH_KEY_MENUS_SH
			else
				echo "        \"$title\" \"$bind\" \"$cmd\" \\" >>$WITCH_KEY_MENUS_SH
			fi
		fi
	fi
done <$TMUX_KEYMAPS

# Add the close menu option
echo "        \"Close Menu\" Escape \"\"" >>$WITCH_KEY_MENUS_SH
echo "}" >>$WITCH_KEY_MENUS_SH

# Make the new witch-key-menus.sh script executable
chmod +x $WITCH_KEY_MENUS_SH
