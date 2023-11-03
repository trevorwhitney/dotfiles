{
  description = "Dotfiles flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (import ../../overlays/neovim.nix)
            ];
            config = { allowUnfree = true; };
          };
        in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              (neovim.override {
                withLspSupport = true;
              })
            ];
          };
        }
      ));
}
