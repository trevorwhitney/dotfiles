#!/bin/bash

set -e

if [[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
	# shellcheck source=/home/twhitney/.nix-profile/etc/profile.d/nix.sh
	. "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

home-manager expire-generations "-7 days"
nix-store --gc

nix-channel --update

if [[ -e /homeless-shelter ]]; then
  sudo rm -rf /homeless-shelter
fi
home-manager switch

nix-store --gc
