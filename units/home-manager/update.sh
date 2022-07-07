#!/bin/bash
current_dir=$(cd "$(dirname "$0")" && pwd)
dot_files_dir=$(cd "${current_dir}/../.." && pwd)

set -e

if [[ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]]; then
	# shellcheck source=/home/twhitney/.nix-profile/etc/profile.d/nix.sh
	. "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi

home-manager expire-generations "-7 days"
nix-store --gc

nix-channel --update

if [[ -e /homeless-shelter ]]; then
  sudo rm -rf /homeless-shelter
fi

pushd "${dot_files_dir}" || exit 1
  home-manager switch --flake .
popd

nix-store --gc
