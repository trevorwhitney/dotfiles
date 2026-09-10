{ stdenvNoCC
, lib
, fetchurl
}:
stdenvNoCC.mkDerivation rec {
  pname = "cua-driver";
  version = "0.26.1";

  src = fetchurl {
    url = "https://github.com/trycua/cua/releases/download/cua-driver-rs-v${version}/cua-driver-rs-${version}-darwin-universal.tar.gz";
    hash = "sha256-BVVHWCPeI9eiI56jDB8V5cTEX3C1CuEqr5S0mBz2sHk=";
  };

  sourceRoot = "cua-driver-rs-${version}-darwin-universal";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R CuaDriver.app "$out/Applications/"
    ln -s "$out/Applications/CuaDriver.app/Contents/MacOS/cua-driver" "$out/bin/cua-driver"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cross-platform desktop automation driver";
    homepage = "https://cua.ai/docs/how-to-guides/driver/install";
    license = licenses.mit;
    mainProgram = "cua-driver";
    platforms = platforms.darwin;
  };
}
