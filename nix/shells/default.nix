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
    inherit secrets;
    pkgs = pkgs.extend loki.overlays.default;
  };

  dev-env = import ./dev-env.nix { inherit pkgs; };

  dev-env-no-eslint-d = import ./dev-env.nix {
    inherit pkgs;
    useEslintDaemon = false;
  };

  loki = import ./loki.nix {
    inherit secrets;
    pkgs = pkgs.extend loki.overlays.default;
  };
  gel = import ./gel.nix { inherit pkgs secrets; };

  prometheus = import ./dev-env.nix {
    inherit pkgs;
    nodeJsPkg = pkgs.nodejs_18;
  };
}
