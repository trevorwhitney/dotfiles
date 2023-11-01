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
        env = pkgs.writers.writeBash "env.sh" ''
          export NODE_PATH="${pkgs.nodejs}/lib/node_modules:$NODE_PATH"
          export NPM_CONFIG_PREFIX="${pkgs.nodejs}"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            gnumake
            go_1_21
            mage
            # swc

            nodejs
            (yarn.override {
              inherit nodejs;
            })

            # python with extra packages needed for scripts
            (
              let
                extra-python-packages = python-packages:
                  with python-packages; [
                    gyp
                  ];
                python-with-packages = python311.withPackages extra-python-packages;
              in
              python-with-packages
            )


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
