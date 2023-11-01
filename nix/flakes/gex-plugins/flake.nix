{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import ../../overlays/neovim.nix)
          ];
          config = { allowUnfree = true; };
        };
        nodejs = pkgs.nodejs_18;

        env = pkgs.writers.writeBash "env.sh" ''
          export NODE_PATH="${nodejs}/lib/node_modules:$NODE_PATH"
          export NPM_CONFIG_PREFIX="${nodejs}"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            gnumake
            go_1_21
            mage

            nodejs
            (yarn.override {
              inherit nodejs;
            })

            (neovim.override {
              withLspSupport = true;
              goPkg = go_1_21;
            })
          ];

          shellHook = ''
            source "${env}"
          '';
        };
      });
}
