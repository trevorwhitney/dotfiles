{ pkgs }:
let
  nodeJsPkg = pkgs.nodejs_22;
  pythonPkg = pkgs.python312.withPackages (ps: with ps; [
    gyp
    tiktoken
    tkinter
    pip
    setuptools
  ]);
in
{
  # Keep the system editor and project editors on the same toolchain.
  editorArgs = {
    inherit nodeJsPkg;
    goPkg = pkgs.go;
    delvePkg = pkgs.delve;
    goplsPkg = pkgs.gopls;
    golangciLintPkg = pkgs.golangci-lint;
    golangciLintLangServerPkg = pkgs.golangci-lint-langserver;
    withLspSupport = true;
  };

  packages = with pkgs; [
    bashInteractive
    git
    gnumake
    go-jsonnet
    jsonnet-bundler
    prettier
    shellcheck
    slackcli
    yamllint
    zip
    go
    delve
    gopls
    golangci-lint
    golangci-lint-langserver
    gotools
    mage
    faillint
    nodeJsPkg
    (yarn.override { nodejs = nodeJsPkg; })
    typescript
    typescript-language-server
    pythonPkg
    vrnsh
    lefthook
    wire

    # Shared Loki/GEL development tools.
    act
    envsubst
    golang-perf
    gox
    graphviz
    helm-docs
    mixtool
    chart-testing-3_8_0
    pprof
    revive
  ];
}
