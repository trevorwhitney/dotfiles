{ pkgs
, useEslintDaemon ? true
, extraPackages ? [ ]
, nodeJsPkg ? pkgs.nodejs_22
, goPkg ? pkgs.go
, delvePkg ? pkgs.delve
, ...
}:
let
  env = pkgs.writers.writeBash "env.sh" ''
    export NODE_PATH="${nodeJsPkg}/lib/node_modules:$NODE_PATH"
    export NPM_CONFIG_PREFIX="${nodeJsPkg}"
  '';
in
pkgs.mkShell {
  packages = with pkgs; [
    # General
    bashInteractive
    git
    gnumake
    go-jsonnet
    jsonnet-bundler
    shellcheck
    zip

    # Golang
    goPkg
    delvePkg
    faillint
    golangci-lint
    gotools
    mage

    # NodeJS
    nodeJsPkg
    (yarn.override {
      nodejs = nodeJsPkg;
    })

    (pkgs.neovim {
      inherit
        goPkg
        delvePkg
        nodeJsPkg
        useEslintDaemon;
      withLspSupport = true;
    })

    # python with extra packages
    (
      let
        extra-python-packages = python-packages:
          with python-packages; [
            gyp
            tiktoken
            pip
            setuptools
          ];
        python-with-packages = python312.withPackages
          extra-python-packages;
      in
      python-with-packages
    )
  ] ++ extraPackages;

  shellHook = ''
    source "${env}"
  '';
}
