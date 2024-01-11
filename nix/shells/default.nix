{ pkgs, secrets, ... }: {
  default = import ./shell.nix { inherit pkgs; };

  deployment-tools = import ./deployment-tools.nix { inherit pkgs secrets; };

  dev-env = import ./dev-env.nix { inherit pkgs; };

  dev-env-no-eslint-d = import ./dev-env.nix {
    inherit pkgs;
    useEslintDaemon = false;
  };

  loki = import ./loki.nix { inherit pkgs secrets; };

  prometheus = import ./dev-env.nix {
    inherit pkgs;
    nodeJsPkg = pkgs.nodejs_18;
  };
}
