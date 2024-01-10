{ pkgs, secrets, ... }:
let
  packages = pkgs.extend (self: super: with super.lib; (foldl' (flip extends) (_: super)
    [
      (import ../overlays/mixtool.nix)
      (import ../overlays/chart-testing.nix)
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
    # chart-releaser
    golang-perf
    chart-testing-3_8_0
    delve
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
    mage
    mixtool
    nettools
    nixpkgs-fmt
    pprof
    revive
    snyk
    statix
    systemd
    trivy
    yamllint

    # Typescript for GitHub Actions
    nodejs
    (yarn.override {
      inherit nodejs;
    })
    nodePackages.typescript
    nodePackages.typescript-language-server

    (packages.neovim.override {
      withLspSupport = true;
      goPkg = go_1_21;
    })
  ];

  shellHook = ''
    source ${packages.secrets}/grafana/deployment-tools.sh
  '';
}

