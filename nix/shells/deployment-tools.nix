{ pkgs, secrets, ... }:
let
  packages = pkgs.extend secrets.overlay;
in
packages.mkShell {
  nativeBuildInputs = [ packages.bashInteractive ];

  packages = with packages; [
    argo
    deployment-tools
    jsonnet
    shellcheck
    kns-ktx

    (pkgs.neovim {
      withLspSupport = true;
      goPkg = go_1_21;
    })

    (packages.logcli.overrideAttrs (old: { doCheck = false; }))
  ];

  shellHook = ''
    source ${packages.secrets}/grafana/deployment-tools.sh
  '';
}
