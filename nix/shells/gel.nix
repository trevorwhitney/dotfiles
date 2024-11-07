{ pkgs, secrets, ... }:
let
  goPkg = pkgs.go_1_23;
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

    act
    golang-perf
    delve
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
      inherit goPkg;
      withLspSupport = true;
      goBuildTags = "requires_docker,linux,cgo,promtail_journal_enabled";
    })
  ];

  shellHook = ''
    source ${pkgs.secrets}/grafana/deployment-tools.sh
  '';
}
