{ pkgs, ... }: {
  default = import ./shell.nix { inherit pkgs; };
  dev-env = import ./dev-env.nix { inherit pkgs; };
}
