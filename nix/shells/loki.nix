{ pkgs, secrets, ... }:
let
  packages = pkgs.extend (self: super: with super.lib; (foldl' (flip extends) (_: super)
    [
      (import ../overlays/mixtool.nix)
      (import ../overlays/chart-testing.nix)
      (import ../overlays/faillint.nix)
      secrets.overlay
    ]
    self));
in
packages.mkShell {
  nativeBuildInputs = [ packages.bashInteractive ];
  buildInputs = with packages; [
    shellcheck
  ];
  packages = with packages; [
    golang-perf
    gotestsum
    chart-testing-3_8_0
    delve
    drone-cli
    envsubst
    faillint
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
    mixtool
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

    (packages.neovim {
      withLspSupport = true;
      goPkg = go_1_21;
      goBuildTags = "linux,cgo,promtail_journal_enabled,integration";
    })


    (packages.loki.overrideAttrs (old: { doCheck = false; }))
    (packages.logcli.overrideAttrs (old: { doCheck = false; }))
    (packages.promtail.overrideAttrs (old: { doCheck = false; }))
  ];

  shellHook = ''
    source ${packages.secrets}/grafana/deployment-tools.sh
  '';
}

