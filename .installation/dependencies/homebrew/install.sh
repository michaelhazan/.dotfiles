# NOTE : This script is not meant to be run directly.
# It is meant to be run as a dependency by init.sh.

# Brewing (installing dependencies)
source ./.installation/common.sh

__check_for_dependency brew

if [ "$UNINSTALL" -eq 0 ]; then
	COMMAND="install"
else
	COMMAND="uninstall"
fi

__install_dependency gum "brew install ${FLAGS[@]} gum"

source .installation/dependencies/homebrew/dependencies.sh

FILTERED_BOTTLES=${BOTTLES[@]}
FILTERED_CASKS=${CASKS[@]}
FILTERED_TAPS="${TAPS[@]}"

if [ "$AUTO_INSTALL" -eq 0 ]; then
	FILTERED_BOTTLES=$(gum choose --header "Select dependencies (bottles) to $COMMAND:" --no-limit ${BOTTLES[@]})
	FILTERED_CASKS=$(gum choose --header "Select dependencies (casks) to $COMMAND:" --no-limit ${CASKS[@]})
	FILTERED_TAPS=$(gum choose --header "Select dependencies (taps) to $COMMAND:" --no-limit "${TAPS[@]}")
fi

__announce_installation "Homebrew"

for BOTTLE in ${FILTERED_BOTTLES[@]}; do
	gum spin --spinner="dot" --title "Installing $BOTTLE" -- brew $COMMAND $BOTTLE
done

for CASK in ${FILTERED_CASKS[@]}; do
	gum spin --spinner="dot" --title "Installing $CASK" -- brew $COMMAND --cask $CASK
done

for TAP in "${FILTERED_TAPS[@]}"; do
	if [[ -z "$TAP" ]]; then
		continue
	fi

	TAP_NAME=$(echo $TAP | cut -d ' ' -f1)
	TAP_REPO=$(echo $TAP | cut -d ' ' -f2)

	if [ "$UNINSTALL" -eq 0 ]; then
		gum spin --spinner="dot" --title "Tapping $TAP_NAME" -- brew tap $TAP_NAME $TAP_REPO
	fi
	gum spin --spinner="dot" --title "Installing $TAP_NAME" -- brew $COMMAND $(echo $TAP_NAME | cut -d '/' -f2)
done
