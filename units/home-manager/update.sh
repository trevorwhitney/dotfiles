#!/bin/bash

set -e


if [[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

home-manager switch
home-manager expire-generations "-7 days"
