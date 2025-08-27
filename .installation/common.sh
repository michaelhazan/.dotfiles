# Check if a dependency is installed, if not, exit
# Params:
#   $1 - Dependency name
__check_for_dependency() {
	if ! command -v $1 >/dev/null 2>&1; then
		echo "Missing \`$1\` executable;" >&2
		echo "If you have \`$1\` installed (or installed without skipping \`brew\`) please report this issue at https://github.com/michaelhazan/.dotfiles/issues" >&2
		exit 1
	fi
}

# Asks the user if they want to install a dependency
# Params:
#   $1 - Dependency name
#   $2 - Command to install the dependency
__install_dependency() {
	if ! command -v $1 >/dev/null 2>&1; then
		echo -e "\033[33mWARNING: $1 is required for this script to work.\033[0m"

		read -p "Install $1? (y/n) " -n 1 -r

		if [[ $REPLY =~ ^[Yy]$ ]]; then
			eval $2
		else
			echo "Exiting."
			exit 1
		fi
	fi
}

# Announce the installation
# Params:
#   $1 - Package manager
__announce_installation() {
	gum style \
		--foreground 212 --border-foreground 200 --border "rounded" \
		--align center --width 50 --margin "1 2" --padding "2 4" \
		"Installing using $1 package manager"
}
