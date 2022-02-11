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
op get document "git secrets" > "${secrets_dir}/git"

nix_config="$(cat "$HOME/.config/dotfiles/host.json")"
nix_user="$(echo "${nix_config}" | jq -r '.nix.user')"
nix_group="$(echo "${nix_config}" | jq -r '.nix.group')"
nix_sandbox="$(echo "${nix_config}" | jq -r '.nix.sandbox.enabled')"

if [[ ! $(grep "^${nix_group}" /etc/group) ]]; then sudo groupadd "${nix_group}"; fi
sudo usermod -aG "${nix_group}" "${nix_user}"

sudo mkdir -p /nix
sudo chown -R "${nix_user}":"${nix_group}" /nix

if [[ "${nix_sandbox}" != "true" ]]; then
  echo "disabling nix sandbox"
  mkdir -p "${HOME}/.config/nix/nix"
  echo 'sandbox = false' >> "${HOME}/.config/nix/nix.conf"
fi

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

if [[ ! -e "${HOME}/.config/nixpkgs" ]]; then
  ln -s "${current_dir}/nixpkgs" "${HOME}/.config/nixpkgs"
fi

if [[ ! -e "${HOME}/.config/nixpkgs/home.nix" ]]; then
  ln -s "${current_dir}/hosts/${host}.nix" "${HOME}/.config/nixpkgs/home.nix"
fi

# enable the docker systemd unit
sudo ln -sf ~/.nix-profile/etc/systemd/system/docker.socket /etc/systemd/system/docker.socket
sudo ln -sf ~/.nix-profile/etc/systemd/system/docker.service /etc/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl enable docker.socket
sudo systemctl enable docker.service
