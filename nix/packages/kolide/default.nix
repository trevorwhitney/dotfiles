{ stdenv, pkgs, lib }:
let
  launcher-raw = stdenv.mkDerivation rec {
    name = "kolide-launcher-raw";
    pname = "kolide-launcher-raw";

    src = ./src;

    installPhase =
      with pkgs;
      ''
        mkdir -p $out/bin

        install -D $src/bin/launcher -t $out/bin
      '';
  };

  launcher =
    pkgs.buildFHSUserEnv {
      name = "launcher";
      targetPkgs = pkgs: [ launcher-raw ];
      multiPkgs = pkgs: [ pkgs.dpkg ];
      runScript = "launcher";
    };
in
stdenv.mkDerivation rec {
  name = "kolide-launcher";
  pname = "kolide-launcher";

  src = ./src;

  buildInputs = with pkgs; [
    rsync
  ];

  # rsync -av --no-group $src/ $out
  installPhase =
    with pkgs;
    ''
      mkdir -p $out/bin
      mkdir -p $out/etc

      install -D ${launcher}/bin/launcher -t $out/bin

      substitute $src/etc/launcher.flags $out/etc/launcher.flags \
        --replace "enroll_secret_path /etc/kolide-k2/secret" "enroll_secret_path ${secrets}/kolide/secret" \
        --replace "osqueryd_path /usr/local/kolide-k2/bin/osqueryd" "osqueryd_path ${osquery}/bin/osqueryd"
    '';

  meta = with lib; {
    description = "Kolide launcher";
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
