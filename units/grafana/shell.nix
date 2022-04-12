with import <nixpkgs> { };

let
  # find historical versions here: https://lazamar.co.uk/nix-versions
  # golangci-lint v1.41.1
  golangci-lint-pkgs = import
    (builtins.fetchTarball {
      url =
        "https://github.com/NixOS/nixpkgs/archive/9986226d5182c368b7be1db1ab2f7488508b5a87.tar.gz";
    })
    { };

  golangci-lint_1_41_1 = golangci-lint-pkgs.golangci-lint;

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
      description =
        "Simple Go linter than fails when specific import paths are present";
      homepage = "https://github.com/fatih/faillint";
      license = licenses.bsd3;
      maintainers = with maintainers; [ trevorwhitney ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  };
in
mkShell {
  nativeBuildInputs = [ faillint gcc go golangci-lint_1_41_1 systemd ];
}
