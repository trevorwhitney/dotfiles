{ pkgs, deploy-rs, ... }:
let
  goPkg = pkgs.go;
  delvePkg = pkgs.delve;
  nodeJsPkg = pkgs.nodejs_22;
in
{
  default = import ./dev-env.nix {
    inherit pkgs;
    extraPackages = with pkgs; [
      deploy-rs.packages.${pkgs.system}.default
      home-manager
      libvirt
      nix
      qemu
      virt-manager
    ];
  };

  dev-env = import ./dev-env.nix { inherit pkgs goPkg delvePkg; };

  grafana = import ./grafana.nix {
    inherit pkgs goPkg delvePkg nodeJsPkg;
  };

  loki = import ./loki.nix {
    inherit pkgs goPkg delvePkg;
  };
  gel = import ./gel.nix { inherit pkgs goPkg delvePkg; };

  prometheus = import ./dev-env.nix {
    inherit pkgs goPkg delvePkg nodeJsPkg;
  };
}
