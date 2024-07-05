{ pkgs
, useEslintDaemon ? true
, extraPackages ? [ ]
, nodeJsPkg ? pkgs.nodejs_20
, goPkg ? pkgs.go_1_22
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
    jsonnet
    zip

    # Golang
    goPkg
    delve
    (import ../packages/faillint {
      inherit (pkgs) lib buildGoModule fetchFromGitHub;
    })
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
          ];
        python-with-packages = python311.withPackages
          extra-python-packages;
      in
      python-with-packages
    )
  ] ++ extraPackages;

  shellHook = ''
    source "${env}"
  '';
}
