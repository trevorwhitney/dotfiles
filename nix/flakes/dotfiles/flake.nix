{
  description = "My dotfiles and overlays";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import ../../overlays/dotfiles.nix) ];
          config = { allowUnfree = true; };
        };
      in
      {
        defaultPackage = pkgs.dotfiles;
        devShell = import ./shell.nix { inherit pkgs; };
        packages = {
          inherit (pkgs)
            dotfiles faillint git-template gocomplete jdtls
            jsonnet-language-server jsonnet-lint kns-ktx mixtool mosh
            oh-my-zsh-custom protoc-gen-gogofast protoc-gen-gogoslick stylua xk6
            tw-tmux-lib;
        };
      }));
}
