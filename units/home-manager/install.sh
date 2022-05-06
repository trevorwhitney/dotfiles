#!/bin/bash
current_dir=$(cd "$(dirname "$0")" && pwd)
dot_files_dir=$(cd "${current_dir}/../.." && pwd)
host_path="$HOME/.config/dotfiles/host.json"
host="$(cat "$host_path" | jq -r '.name')"

# shellcheck source=../../lib.sh
source "${dot_files_dir}/lib.sh"

# Fetch secrets from 1password
op_signin
secrets_dir="${current_dir}/nixpkgs/secrets"
mkdir -p "${secrets_dir}"
op get document "git secrets" >"${secrets_dir}/git"

nix_config="$(cat "$HOME/.config/dotfiles/host.json")"
nix_user="$(echo "${nix_config}" | jq -r '.nix.user')"
nix_group="$(echo "${nix_config}" | jq -r '.nix.group')"
nix_sandbox="$(echo "${nix_config}" | jq -r '.nix.sandbox.enabled')"

if [[ ! $(grep "^${nix_group}" /etc/group) ]]; then sudo groupadd "${nix_group}"; fi
sudo usermod -aG "${nix_group}" "${nix_user}"

sudo mkdir -p /nix
sudo chown -R "${nix_user}":"${nix_group}" /nix

mkdir -p "${HOME}/.config/nix/nix"
if [[ "${nix_sandbox}" != "true" ]]; then
	echo "disabling nix sandbox"
	echo 'sandbox = false' >>"${HOME}/.config/nix/nix.conf"
fi
echo 'experimental-features = nix-command flakes' >>"${HOME}/.config/nix/nix.conf"

nix_profile="${HOME}/.nix-profile/etc/profile.d/nix.sh"
if [[ -e "${nix_profile}" ]]; then
	. "${nix_profile}"
fi

test ! "$(command -v nix)" && curl -L https://nixos.org/nix/install | sh

if [[ ! $(command -v home-manager) ]]; then
	. "${HOME}/.nix-profile/etc/profile.d/nix.sh"
	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	export NIX_PATH=${HOME}/.nix-defexpr/channels${NIX_PATH:+:}${NIX_PATH}
	nix-shell '<home-manager>' -A install
fi

mkdir -p "${HOME}/.config/nixpkgs"
for dir in lib modules pkgs secrets; do
	if [[ ! -e "${HOME}/.config/nixpkgs/${dir}" ]]; then
		ln -sf "${current_dir}/nixpkgs/${dir}" "${HOME}/.config/nixpkgs/${dir}"
	fi
done

if [[ ! -e "${HOME}/.config/nixpkgs/home.nix" ]]; then
	ln -s "${current_dir}/hosts/${host}.nix" "${HOME}/.config/nixpkgs/home.nix"
fi

home-manager switch

"${current_dir}/link-systemd-units.sh"

if [[ ! -e "${HOME}/todo" ]]; then
	git clone git@github.com:trevorwhitney/todo "${HOME}/todo"
fi
