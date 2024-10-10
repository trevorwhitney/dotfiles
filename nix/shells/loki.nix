{ pkgs, secrets, ... }: 
let
  goPkg = pkgs.go_1_23;
in 
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.bashInteractive
  ];
  buildInputs = with pkgs; [
    shellcheck
  ];
  packages = with pkgs; [
    (import ../packages/mixtool { inherit (pkgs) lib buildGoModule fetchFromGitHub; })
    (import ../packages/chart-testing/3_8_0.nix {
      inherit (pkgs) system;
      pkgs = pkgs;
    })

    (pkgs.neovim {
      inherit goPkg;
      withLspSupport = true;
      goBuildTags = "linux,cgo,promtail_journal_enabled,integration";
      dapConfigurations = {
        go = [
          {
            type = "go";
            name = "Loki main";
            request = "launch";
            program = ''''${workspaceFolder}/cmd/loki/main.go'';
            args = [
              ''-config.file=''${workspaceFolder}/cmd/loki/loki-local-config.yaml''
            ];
          }
        ];
      };
    })

    goPkg

    crane
    delve
    drone-cli
    envsubst
    faillint
    gcc
    gnumake
    golang-perf
    golangci-lint
    gotestsum
    gotools
    gox
    graphviz
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
    yq-go

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
