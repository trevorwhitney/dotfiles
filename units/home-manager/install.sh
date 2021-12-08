#!/bin/bash
current_dir=$(cd "$(dirname $0)" && pwd)

# TODO: separate steps needed on crostini
# mkdir -p ~/.config/nix/nix
# specify sandbox.enable
# echo 'sandbox = false' >> ~/.config/nix/nix.conf
# sudo groupadd nix-users
# sudo usermod -aG nix-users twhitney
# mkdir -p /nix
# sudo chown -R twhitney:nix-users /nix
# specify nix user and group

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
