{
  description = "Config for i3 with gnome via gnome-flashback";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    {
      overlay = final: prev: {
        i3-gnome-flashback =
          prev.callPackage ./default.nix { inherit (prev) runCommand; };
      };
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in
      {
        defaultPackage = pkgs.i3-gnome-flashback;
        devShell = import ./shell.nix { inherit pkgs; };
        packages = { inherit (pkgs) i3-gnome-flashback; };
      }));
}
