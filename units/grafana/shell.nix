with import <nixpkgs> { };

let
  # find historical versions here: https://lazamar.co.uk/nix-versions
  # golangci-lint v1.41.1
  golangci-lint-pkgs = import (builtins.fetchTarball {
    url =
      "https://github.com/NixOS/nixpkgs/archive/9986226d5182c368b7be1db1ab2f7488508b5a87.tar.gz";
  }) { };
  golangci-lint_1_41_1 = golangci-lint-pkgs.golangci-lint;

  helm-docs-1_8_1 = buildGoModule rec {
    pname = "helm-docs";
    version = "1.8.1";

    src = fetchFromGitHub {
      owner = "norwoodj";
      repo = "helm-docs";
      rev = "v${version}";
      sha256 = "1z4w0kprdimdfjidpqasn558rdgx62lqdi6vj9xbkn2vh04vz51s";
    };

    vendorSha256 = "FpmeOQ8nV+sEVu2+nY9o9aFbCpwSShQUFOmyzwEQ9Pw=";

    subPackages = [ "cmd/helm-docs" ];
    ldflags = [ "-w" "-s" "-X main.version=v${version}" ];

    meta = with lib; {
      homepage = "https://github.com/norwoodj/helm-docs";
      description =
        "A tool for automatically generating markdown documentation for Helm charts";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ trevorwhitney ];
    };
  };

  dotfiles = (builtins.getFlake (toString ../../nix/flakes/dotfiles)).packages.x86_64-linux;

in mkShell {
  nativeBuildInputs = [
    gcc
    go
    golangci-lint_1_41_1
    systemd
    helm-docs-1_8_1
    yamllint

    dotfiles.faillint
    dotfiles.mixtool
  ];
}
