{ pkgs, secrets, ... }:
let
  packages = pkgs.extend secrets.overlay;
in
packages.mkShell {
  nativeBuildInputs = [ packages.bashInteractive ];
  buildInputs = with packages; [
    shellcheck
  ];

  packages = with packages; [
    argo
    shellcheck

    (pkgs.neovim.override {
      withLspSupport = true;
      goPkg = go_1_21;
    })
  ];

  shellHook = ''
    source ${packages.secrets}/grafana/deployment-tools.sh
  '';
}
