# NOTE : This script is not meant to be run directly.
# It is meant to be run as a dependency by init.sh.
# Stowing (symlinking packages)
source ./.installation/common.sh

__check_for_dependency gum
__check_for_dependency stow

PACKAGES=$(ls -d */)

if [ "$AUTO_STOW" -eq 0 ]; then
    PACKAGES=$(gum choose --header "Select packages to stow:" --no-limit $PACKAGES)
fi

for PACKAGE in $PACKAGES; do
    if [ "$UNINSTALL" -eq 0 ]; then
        gum spin --spinner="dot" --title "Stowing $PACKAGE" -- stow $PACKAGE
    else
        gum spin --spinner="dot" --title "Un-stowing $PACKAGE" -- stow -Dv $PACKAGE
    fi
done
