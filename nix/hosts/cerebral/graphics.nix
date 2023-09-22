{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    clinfo
    glxinfo
    vulkan-tools
  ];
}
