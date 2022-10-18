{ pkgs, lib, config, ... }: {
  nix.settings.trusted-users = [ "twhitney" ];

  users.users.twhitney = {
    isNormalUser = true;
    description = "Trevor Whitney";
    home = "/home/twhitney";
    extraGroups = [ "wheel" "networkmanager" "vboxsf" "docker" "plex" ];
    openssh.authorizedKeys.keys = [
      # cerebral
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSeuF+NMj8sKD8kWuahlSasaPzHzT5Jhip+Y+EAcfEv trevorjwhitney@gmail.com"
      # crostini
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINX1x10BU/7kbO24ZtX7Lz6IHd55KiWt0cMdlxlTHjlp trevorjwhitney@gmail.com"
    ];
    shell = pkgs.zsh;
    hashedPassword = "$6$yk8kVONJVBtnD8i9$S0GR95lpXGOZ0cNLy.sZiaPuShpK/tgS9TjIcyvKqDKib9Fi5onZb6aPN9tj9zlMVhDQbvlHmb/YHTmiTZ0Ms1";
    uid = 1000;
  };
}
