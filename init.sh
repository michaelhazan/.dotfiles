#!/bin/sh

AUTO_STOW=1
STOW=1

AUTO_INSTALL=1
INSTALLATION="homebrew"
UNINSTALL=0

# {{{ Help Message
HELP_MESSAGE="
Usage: ./init.sh [--help] [--stow | --manual-stow | --no-stow] [--brew | --manual-brew | --no-brew] [--uninstall]\n\n
.  Installs all of the dependencies required for my dotfiles, and stows the packages.\n
\n
.  STOWING:\n
.    Run with \`(--stow | -s)\` to automatically \`stow\` all of the packages. (default)\n
.    Run with \`(--manual-stow | -ms)\` to manually choose which packages to \`stow\`.\n
.    Run with \`(--no-stow | -ns)\` to skip the \`stowing\` process.\n
\n\n
.  PACKAGE MANAGERS:\n
.    Run with \`(--no-install | -ni)\` to skip the dependency installer.\n
\n
.	BREWING:\n
.      Run with \`(--brew | -b)\` to automatically install all of the dependencies using \033[33mHomebrew\033[0m. (default)\n
.      Run with \`(--manual-brew | -mb)\` to manually choose which dependencies to install.\n
\n\n
.  UNINSTALLING:\n
.    Run with \`(--uninstall | -ui)\` to uninstall all of the dependencies and \`stow\` packages.\n
.    \033[33mWARNING: Uninstalling without disabling the dependency installer will uninstall all of the dependencies that could be installed by the installer.\033[0m\n
"
# }}}

# {{{ Arguments
for ARG in "$@"; do
	case $ARG in
	-s | --stow)
		AUTO_STOW=1
		STOW=1
		;;
	-ms | --manual-stow)
		AUTO_STOW=0
		STOW=1
		;;
	-ns | --no-stow)
		STOW=0
		;;

	-b | --brew)
		AUTO_INSTALL=1
		INSTALLATION="homebrew"
		;;
	-mb | --manual-brew)
		AUTO_INSTALL=0
		INSTALLATION="homebrew"
		;;

	-ni | --no-install)
		AUTO_INSTALL=0
		INSTALLATION="none"
		;;
	--uninstall)
		UNINSTALL=1
		;;

	-h | --help | *)
		echo $HELP_MESSAGE
		exit 0
		;;

	esac
done
# }}}

# {{{ Flags
export UNINSTALL
# }}}

# {{{ Dependencies
export AUTO_INSTALL
case $INSTALLATION in
none)
	echo "\n\x1b[0;35;49mSkipping dependency installer.\x1b[0m"
	;;
*)
	INSTALLER_PATH="./.installation/dependencies/$INSTALLATION/install.sh"
	if [ -f "$INSTALLER_PATH" ]; then
		chmod +x "$INSTALLER_PATH"
		eval "$INSTALLER_PATH"
	else
		echo "\033[33mMissing dependency installer for \033[31m$INSTALLATION\033[33m. Exiting.\033[33m"
		exit 1
	fi
	;;
esac
# }}}

# {{{ Packages
export AUTO_STOW
case $STOW in
0)
	echo "\n\x1b[0;35;49mSkipping \`stow\` process.\x1b[0m"
	;;
1)
	PACKAGES_PATH="./.installation/stow.sh"
	if [ -f "$PACKAGES_PATH" ]; then
		chmod +x "$PACKAGES_PATH"
		eval "$PACKAGES_PATH"
	else
		echo -e "\n\033[33mMissing \`stow.sh\` script, somehow.... Exiting.\033[33m"
		exit 1
	fi
	;;
esac

# }}}

# vim: foldmethod=marker
