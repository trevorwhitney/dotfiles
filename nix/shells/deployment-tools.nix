{ pkgs, secrets, ... }:
let
  ss = (pkgs.extend secrets.overlay).secrets;
in
pkgs.mkShell {
  nativeBuildInputs = [ pkgs.bashInteractive ];

  packages = with pkgs; [
    ss

    argo
    deployment-tools
    jsonnet
    shellcheck
    kns-ktx

    (pkgs.neovim {
      withLspSupport = true;
      goPkg = go_1_21;
    })
  ];

  shellHook = ''
    source ${pkgs.secrets}/grafana/deployment-tools.sh
  '';
}
