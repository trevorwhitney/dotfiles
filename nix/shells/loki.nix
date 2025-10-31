{ pkgs, ... }: 
let
  goPkg = pkgs.go;
  golangciLintPkg = pkgs.golangci-lint;
  golangciLintLangServerPkg = pkgs.golangci-lint-langserver;
  delvePkg = pkgs.delve;
  nodeJsPkg = pkgs.nodejs_22;
  goplsPkg = pkgs.gopls;
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
      inherit goPkg delvePkg nodeJsPkg golangciLintPkg golangciLintLangServerPkg goplsPkg;
      withLspSupport = true;
      goBuildTags = "integration";
      dapConfigurations =
        let
          ports = {
            "Distributor" = 18001;
            "Ingester" = 18002;
            "Querier" = 18004;
            "Query Frontend" = 18007;
            "Pattern Ingester" = 18010;
            "Partition Ring" = 18020;
            "Dataobj Index Builder" = 18021;
            "Dataobj Consumer" = 18020;
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

    goPkg
    goplsPkg
    delvePkg
    golangciLintPkg
    golangciLintLangServerPkg

    act
    crane
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
    mysql-client
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
    nodeJsPkg
    (yarn.override {
      nodejs = nodeJsPkg;
    })
    nodePackages.typescript
    nodePackages.typescript-language-server

    (pkgs.loki.overrideAttrs (old: { doCheck = false; }))
    (pkgs.promtail.overrideAttrs (old: { doCheck = false; }))
  ];
}
