with import <nixpkgs> {};

let
  golangci-lint = buildGoModule rec {
    pname = "golangci-lint";
    version = "1.41.1";

    src = fetchFromGitHub {
      owner = "golangci";
      repo = "golangci-lint";
      rev = "v${version}";
      sha256 = "1lcfp924zc98rlsv68v7z7f7i7d8bzijmlrahsbqivmhdd9j86pg";
    };

    vendorSha256 = "s0ZFQJIhF23FtLol1Gegljf6eyGkCmVxTKmHbQBtPvM=";

    subPackages = [ "cmd/golangci-lint" ];

    meta = with lib; {
      description = "Fast Go linters and runners";
      homepage = "https://github.com/golangci/golangci-lint";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ trevorwhitney ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  };

  faillint = buildGoModule rec {
    pname = "faillint";
    version = "1.5.0";

    src = fetchFromGitHub {
      owner = "fatih";
      repo = "faillint";
      rev = "v${version}";
      sha256 = "0viqq29w8jvqpirldx3n0r1j17kmgwqy4z0grj0j77yq13p60jmr";
    };

    vendorSha256 = "s6TG6kp64LYGPNynoBNbJvbDmT+9XgaWZewTTsi/NXs=";
    doCheck = false;

    meta = with lib; {
      description = "Fast Go linters and runners";
      homepage = "https://github.com/golangci/golangci-lint";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ trevorwhitney ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  };
in
mkShell { nativeBuildInputs = [ go gcc systemd golangci-lint faillint]; }
