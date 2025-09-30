{ config, ... }: {
  nix = {
    buildMachines = [
      {
        hostName = "10.11.0.74";
        sshUser = "twhitney";
        system = "x86_64-linux";
        maxJobs = 2;
        supportedFeatures = [ "nixos-test" "kvm" ];
        sshKey = "${config.users.users.twhitney.home}/.config/agenix/id_ed25519";
      }
    ];
  };
}
