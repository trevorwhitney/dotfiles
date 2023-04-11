{ nix-alien, system }:
final: prev:
let
  nix-alien-pkgs = nix-alien.packages.${system};
in
{
  inherit (nix-alien-pkgs) nix-alien;
}
