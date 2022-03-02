{ stdenv, fetchzip, lib, pkgs }:
stdenv.mkDerivation rec {
  pname = "jdtls";
  version = "1.9.0-202202240210";

  src = fetchzip {
    url =
      "https://download.eclipse.org/jdtls/snapshots/jdt-language-server-${version}.tar.gz";
    sha256 = "0pq3njzl8knp1jsgp6rd9gyippzb6wrwdif6rjjqw9q2bjbi2xz0";
    stripRoot = false;
  };

  buildInputs = with pkgs; [ rsync ];
  installPhase = ''
    mkdir -p $out
    rsync -av $src/ $out
  '';

  meta = with lib; {
    description = "Java Langauge Server";
    homepage = "https://github.com/eclipse/eclipse.jdt.ls";
    license = licenses.epl20;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
