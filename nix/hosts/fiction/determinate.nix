
{ ... }: {
  nix = {
    # determinate nix runs it's own nix-daemon
    enable = false;
  };

  determinate-nix.customSettings = {
    extra-experimental-features = "external-builders";
    external-builders = builtins.toJSON [
      {
        args = [ "builder" ];
        program = "/usr/local/bin/determinate-nixd";
        systems = [ "aarch64-linux" "x86_64-linux" ];
      }
    ];
  };
}
