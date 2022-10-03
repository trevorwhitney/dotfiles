{
  description = "Stem NixOS System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpks.follows = "nixpkgs";
    neovim.inputs.flake-utils.follows = "flake-utils";

    #TODO: replace with https://github.com/ryantm/agenix
    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=ea38cf5ecec5b6a0eebb8bbe1416bcff4bea55aa";
    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";

    dotfiles.url = "./nix/flakes/dotfiles";
    dotfiles.inputs.nixpkgs.follows = "nixpkgs";
    dotfiles.inputs.flake-utils.follows = "flake-utils";

    i3-gnome-flashback.url = "./nix/flakes/i3-gnome-flashback";
    i3-gnome-flashback.inputs.nixpkgs.follows = "nixpkgs";
    i3-gnome-flashback.inputs.flake-utils.follows = "flake-utils";

    # For running OpenGL apps outside of NixOS
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.inputs.flake-utils.follows = "flake-utils";

    # Firefox nightly
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";
  };

  outputs =
    { self
    , dotfiles
    , flake-utils
    , home-manager
    , i3-gnome-flashback
    , neovim
    , nixgl
    , nixpkgs
    , nixpkgs-mozilla
    , secrets
    , ...
    }:
    let
      overlays = [
        neovim.overlay
        dotfiles.overlay
        secrets.overlay
        i3-gnome-flashback.overlay
        nixgl.overlay
        nixpkgs-mozilla.overlays.firefox
      ];

      pkgs = import nixpkgs {
        inherit overlays;
        config = { allowUnfree = true; };
      };

      nix = import ./nix { inherit self pkgs flake-utils home-manager; };
    in
    {
      nixosConfigurations = {
        inherit (nix.hosts) stem;
      };
    } // (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      defaultPackage = pkgs.dotfiles;
      devShell = import ./shell.nix { inherit pkgs; };
      packages = {
        inherit (pkgs) dotfiles i3-gnome-flashback;
        homeConfigurations = {
          inherit (nix.homes."${system}") "twhitney@cerebral";
        };
      };
    }));
}
