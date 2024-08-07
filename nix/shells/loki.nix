{ pkgs, secrets, ... }: pkgs.mkShell {
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
    (import ../packages/faillint {
      inherit (pkgs) lib buildGoModule fetchFromGitHub;
    })

    (pkgs.neovim {
      withLspSupport = true;
      goPkg = pkgs.go_1_21;
      goBuildTags = "linux,cgo,promtail_journal_enabled,integration";
    })

    golang-perf
    gotestsum
    delve
    drone-cli
    envsubst
    gcc
    graphviz
    gnumake
    go_1_21
    golangci-lint
    gotools
    gox
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

    (pkgs.loki.overrideAttrs (old: { doCheck = false; }))
    (pkgs.promtail.overrideAttrs (old: { doCheck = false; }))
  ];

  shellHook = ''
    source ${pkgs.secrets}/grafana/deployment-tools.sh
  '';
}
