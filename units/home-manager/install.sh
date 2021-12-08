#!/usr/bin/bash
current_dir=$(cd "$(dirname $0)" && pwd)

# TODO: separate steps needed on crostini
# mkdir -p ~/.config/nix/nix
# echo 'sandbox = false' >> ~/.config/nix/nix.conf
# sudo groupadd nix-users
# sudo usermod -aG nix-users twhitney
# mkdir -p /nix
# sudo chown -R twhitney:nix-users /nix

if [[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
  . $HOME/.nix-profile/etc/profile.d/nix.sh
fi

test ! `command -v nix` && curl -L https://nixos.org/nix/install | sh
if [[ ! `command -v home-manager` ]]; then
  . $HOME/.nix-profile/etc/profile.d/nix.sh
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
fi

if [[ ! -e "$HOME/.config/nixpkgs" ]]; then
  ln -s $current_dir/nixpkgs "$HOME/.config/nixpkgs"
fi
