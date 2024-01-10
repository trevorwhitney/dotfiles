{ pkgs, secrets, ... }: {
  default = import ./shell.nix { inherit pkgs; };
  dev-env = import ./dev-env.nix { inherit pkgs; };
  deployment-tools = import ./deployment-tools.nix { inherit pkgs secrets; };
  loki = import ./loki.nix { inherit pkgs secrets; };
}
