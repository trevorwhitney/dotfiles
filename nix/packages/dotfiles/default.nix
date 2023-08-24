{ stdenv, pkgs, lib }:
stdenv.mkDerivation rec {
  name = "dotfiles";
  pname = "dotfiles";

  src = ./src;

  buildInputs = with pkgs; [
    rsync
  ];

  # rsync -av --no-group $src/ $out
  installPhase = with pkgs;
    ''
      mkdir -p $out
      rsync -av --no-group $src/ $out
    '';

  meta = with lib; {
    description = "My dotfiles and nix overlays";
    homepage = "https://github.com/trevorwhitney/dotfiles";
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
