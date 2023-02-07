{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nodejs = pkgs.nodejs-16_x;

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
            go
            mage

            nodejs
            (yarn.override {
              inherit nodejs;
            })
          ];

          shellHook = ''
            source "${env}"
          '';
        };
      });
}
