{
  stdenv,
  pkgs,
  lib,
}:
stdenv.mkDerivation rec {
  name = "claude";
  pname = "claude";

  src = ./src;

  buildInputs = with pkgs; [
    rsync
  ];

  # rsync -av --no-group $src/ $out
  installPhase = with pkgs; ''
    mkdir -p $out
    rsync -av --no-group $src/ $out
  '';

  meta = with lib; {
    description = "Claude code configurations";
    homepage = "https://github.com/trevorwhitney/dotfiles";
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
