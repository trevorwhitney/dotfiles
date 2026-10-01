{ pkgs, ... }:
let
  developmentTools = import ../development-tools.nix { inherit pkgs; };
in
{
  default = pkgs.mkShell {
    packages = pkgs.lib.optionals (!pkgs.stdenv.isDarwin) developmentTools.packages
      ++ [ (pkgs.neovim developmentTools.editorArgs) ];
  };

  loki = import ./loki.nix { inherit pkgs; };
  gel = import ./gel.nix { inherit pkgs; };
}
