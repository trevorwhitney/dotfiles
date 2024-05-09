{ pkgs, ... }: {
  config = {
    home.packages = [
      pkgs.deployment-tools
    ];
  };
}
