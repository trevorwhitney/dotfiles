{
  # enable automatic updates
  system.autoUpgrade = {
    enable = true;
    flake = "/home/twhitney/workspace/dotfiles";
    flags = [
      # update everything but secrets
      "--update-input" "flake-utils"
      "--update-input" "home-manager"
      "--update-input" "neovim"
      "--update-input" "nix-alien"
      "--update-input" "nixgl"
      "--update-input" "nixos-hardware"
      "--update-input" "nixpkgs"
      "--update-input" "nixpkgs-mozilla"
      "--update-input" "nixpkgs-unstable"
      "--update-input" "nur"
    ];
  };
}
