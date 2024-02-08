# Fiction Setup

1. Install nix `sh <(curl -L https://nixos.org/nix/install)`
1. Enable nix-command and flakes by adding the following to `/etc/nix/nix.conf`

    ```nix
    experimental-features = nix-command flakes
    ```

1. Run `nix develop` at the root of dotfiles to get a shell with `home-manager`, then run `home-managesr switch --flake .`
1. Link kitty config since this file needs to be writable because of how I change backgrounds.
1. Install homebrew `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
1. Install homebrew bundle `brew bundle --file hosts/fiction/Brewfile`
1. Copy `sudo_local` to `/etc/pam.d`
