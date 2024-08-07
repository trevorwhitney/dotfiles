{ pkgs, secrets, loki, ... }: {
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

  deployment-tools = import ./deployment-tools.nix {
    inherit secrets pkgs;
  };

  dev-env = import ./dev-env.nix { inherit pkgs; };

  dev-env-no-eslint-d = import ./dev-env.nix {
    inherit pkgs;
    useEslintDaemon = false;
  };

  grafana = import ./grafana.nix { inherit pkgs; };

  loki = import ./loki.nix {
    inherit secrets pkgs;
  };
  gel = import ./gel.nix { inherit pkgs secrets; };

  prometheus = import ./dev-env.nix {
    inherit pkgs;
    nodeJsPkg = pkgs.nodejs_18;
  };
}
