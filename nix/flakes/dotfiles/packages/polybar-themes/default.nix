{ stdenv, fetchFromGitHub, lib, pkgs }:
stdenv.mkDerivation rec {
  pname = "polybary-themes";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "polybar-themes";
    rev = "4295e7e25dab2945913b48a50388dfbfdf13cd9c";
    sha256 = "sha256-VvjFHmq4x/ZqzKpgkeL/Hv07YH0DVEa2WZ0jsu9K11Y=";
  };

  buildInputs = with pkgs; [ rsync ];
  installPhase = ''
        mkdir -p $out/polybar
        mkdir -p $out/polybar-fonts

    		rsync -av --no-group $src/simple/ $out/polybar
    		rsync -av --no-group $src/fonts/ $out/polybar-fonts
  '';

  meta = with lib; {
    description = "Polybar themes";
    homepage = "https://github.com/adi1090x/polybar-themes";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux;
  };
}
