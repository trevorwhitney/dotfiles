{ config, ... }: {
  nix = {
    # distributedBuilds = true;
    linux-builder.enable = true;
    buildMachines = [
      {
        hostName = "mickey.trevorwhitney.net";
        sshUser = "twhitney";
        system = "x86_64-linux";
        maxJobs = 2;
        supportedFeatures = [ "nixos-test" "kvm" ];
        sshKey = "${config.users.users.twhitney.home}/.config/agenix/id_ed25519";
      }
    ];
  };
}
