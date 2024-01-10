{ pkgs, ... }:
let
  _pkgs = pkgs.extend (import ../overlays/faillint.nix);

  nodejs = _pkgs.nodejs_20;
  goPkg = _pkgs.go_1_21;

  env = _pkgs.writers.writeBash "env.sh" ''
    export NODE_PATH="${nodejs}/lib/node_modules:$NODE_PATH"
    export NPM_CONFIG_PREFIX="${nodejs}"
  '';
in
_pkgs.mkShell {
  packages = with _pkgs; [
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
