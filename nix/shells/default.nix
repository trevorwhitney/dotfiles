{ pkgs, loki, ... }:
let
  goPkg = pkgs.go;
  delvePkg = pkgs.delve;
  nodeJsPkg = pkgs.nodejs_22;
in
{
  default = import ./dev-env.nix {
    inherit pkgs;
    extraPackages = with pkgs; [
      deploy-rs.deploy-rs
      home-manager
      libvirt
      nix
      qemu
      virt-manager
    ];
  };

  dev-env = import ./dev-env.nix { inherit pkgs goPkg delvePkg; };

  dev-env-no-eslint-d = import ./dev-env.nix {
    inherit pkgs;
    useEslintDaemon = false;
  };

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
