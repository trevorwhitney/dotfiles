# Fiction Setup

1. Install nix `sh <(curl -L https://nixos.org/nix/install)`
1. Enable nix-command and flakes by adding the following to `/etc/nix/nix.conf`

   ```nix
   experimental-features = nix-command flakes
   ```

1. Install homebrew `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
1. Remove `~/.ssh/config` and the automatically the 1Password ssh agent via 1Password settings
1. Copy `sudo_local` to `/etc/pam.d`
1. Run `nix develop` at the root of dotfiles, then run `nix run nix-darwin -- switch --flake .`
