{ pkgs, ... }:
let
  goPkg = pkgs.go;
  delvePkg = pkgs.delve;
  nodejs = pkgs.nodejs_22;
  nodeJsPkg = pkgs.nodejs_22;


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
      inherit goPkg delvePkg nodeJsPkg;
      withLspSupport = true;
      goBuildTags = "requires_docker,slicelabels";
      dapConfigurations =
        let
          ports = {
            "Distributor" = 18001;
            "Ingester" = 18002;
            "Querier" = 18004;
            "Query Frontend" = 18007;
            "Pattern Ingester" = 18010;
          };

          remoteDebugConfigs = (builtins.map
            (service: {
              type = "go";
              request = "attach";
              mode = "remote";
              name = "Compose ${service}";
              dlvToolPath = "${pkgs.delve}/bin/dlv";
              remotePath = "/loki/loki";
              port = ports.${service};
              cwd = ''''${workspaceFolder}'';
              showLog = true;
            })
            (builtins.attrNames ports));

        in
        {
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
          ] ++ remoteDebugConfigs;
        };
    })
  ];
}
