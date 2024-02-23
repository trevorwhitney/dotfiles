{ pkgs, secrets, ... }:
let
  packages = pkgs.extend secrets.overlay;
in
packages.mkShell {
  nativeBuildInputs = [ packages.bashInteractive ];

  packages = with packages; [
    argo
    jsonnet
    shellcheck
    kns-ktx

    (pkgs.neovim {
      withLspSupport = true;
      goPkg = go_1_21;
    })
  ];

  shellHook = ''
    source ${packages.secrets}/grafana/deployment-tools.sh
  '';
}
