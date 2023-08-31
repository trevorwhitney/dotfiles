{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    clinfo
  ];
}
