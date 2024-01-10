{ pkgs, ... }:
let
  packages = pkgs.extend (import ../overlays/faillint.nix);

  nodejs = packages.nodejs_20;
  goPkg = packages.go_1_21;

  env = packages.writers.writeBash "env.sh" ''
    export NODE_PATH="${nodejs}/lib/node_modules:$NODE_PATH"
    export NPM_CONFIG_PREFIX="${nodejs}"
  '';
in
packages.mkShell {
  packages = with packages; [
    # General
    bashInteractive
    gnumake
    zip

    # Golang
    delve
    go_1_21
    gotools
    golangci-lint
    faillint
    mage

    # NodeJS
    nodejs
    (yarn.override {
      inherit nodejs;
    })

    (pkgs.neovim.override {
      inherit goPkg;
      nodeJsPkg = nodejs;
      withLspSupport = true;
    })

    # python with extra packages needed for scripts
    (
      let
        extra-python-packages = python-packages:
          with python-packages; [
            gyp
          ];
        python-with-packages = python311.withPackages
          extra-python-packages;
      in
      python-with-packages
    )
  ];

  shellHook = ''
    source "${env}"
  '';
}
