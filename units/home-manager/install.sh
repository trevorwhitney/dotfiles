#!/bin/bash
current_dir=$(cd "$(dirname $0)" && pwd)

nix_config="$(cat "$HOME/.config/dotfiles/host.json")"
nix_user="$(echo "$nix_config" | jq -r '.nix.user')"
nix_group="$(echo "$nix_config" | jq -r '.nix.group')"
nix_sandbox="$(echo "$nix_config" | jq -r '.nix.sandbox.enabled')"

if [[ ! $(grep "^$nix_group" /etc/group) ]]; then sudo groupadd "$nix_group"; fi
sudo usermod -aG "$nix_group" "$nix_user"

mkdir -p /nix
sudo chown -R "$nix_user":"$nix_group" /nix

if [[ "$nix_sandbox" != "true" ]]; then
  echo "disabling nix sandbox"
  mkdir -p "$HOME/.config/nix/nix"
  echo 'sandbox = false' >> "$HOME/.config/nix/nix.conf"
fi

. "$HOME/.nix-profile/etc/profile.d/nix.sh"

test ! $(command -v nix) && curl -L https://nixos.org/nix/install | sh

if [[ ! $(command -v home-manager) ]]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
  nix-shell '<home-manager>' -A install
fi

if [[ ! -e "$HOME/.config/nixpkgs" ]]; then
  ln -s "$current_dir/nixpkgs" "$HOME/.config/nixpkgs"
fi
