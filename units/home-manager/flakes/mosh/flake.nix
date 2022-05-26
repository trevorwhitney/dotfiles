{
  description = "Mosh: the mobile shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    {
      overlay = (final: prev: {
        mosh = prev.callPackage ./default.nix { pkgs = prev; };
      });
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in {
        defaultPackage = pkgs.mosh;
        devShell = import ./shell.nix { inherit pkgs; };
        packages = { mosh = pkgs.mosh; };
      }));
}
