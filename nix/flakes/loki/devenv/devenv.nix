{ pkgs, inputs, ... }:

{
  packages = with pkgs; [
    chart-releaser
    chart-testing-3_8_0
    delve
    envsubst
    faillint
    gcc
    go
    golangci-lint
    gotools
    gox
    helm-docs
    mixtool
    nettools
    nixpkgs-fmt
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
  ];

  enterShell = ''
    source ${pkgs.secrets}/grafana/deployment-tools.sh
  '';

  languages.nix.enable = true;
  languages.go.enable = true;
  languages.go.package = pkgs.go_1_20;
}
