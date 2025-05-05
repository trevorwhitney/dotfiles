{ pkgs, ... }:
let
  goPkg = pkgs.go;
  delvePkg = pkgs.delve;
in pkgs.mkShell {
  nativeBuildInputs = [ pkgs.bashInteractive ];
  buildInputs = with pkgs; [
    shellcheck
  ];
  packages = with pkgs; [
    (import ../packages/mixtool { inherit (pkgs) lib buildGoModule fetchFromGitHub; })
    (import ../packages/chart-testing/3_8_0.nix {
      inherit (pkgs) system;
      pkgs = pkgs;
    })

    goPkg
    delvePkg

    act
    golang-perf
    drone-cli
    envsubst
    gcc
    graphviz
    gnumake
    golangci-lint
    gotools
    gox
    faillint
    helm-docs
    jsonnet
    jsonnet-bundler
    mage
    nettools
    nixpkgs-fmt
    pprof
    revive
    snyk
    statix
    trivy
    yamllint

    # Typescript for GitHub Actions
    nodejs
    (yarn.override {
      inherit nodejs;
    })
    nodePackages.typescript
    nodePackages.typescript-language-server

    (pkgs.neovim {
      inherit goPkg delvePkg;
      withLspSupport = true;
      goBuildTags = "requires_docker";
    })
  ];
}
