{ pkgs, lib, config, ... }: {
  nix.settings.trusted-users = [ "twhitney" ];

  users.users.twhitney = {
    isNormalUser = true;
    description = "Trevor Whitney";
    home = "/home/twhitney";
    extraGroups = [ "wheel" "networkmanager" "vboxsf" "vboxusers" "docker" "plex" ];
    openssh.authorizedKeys.keys = [
      # cerebral
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObaPLIJ0t6iar5DTKRmKCQmFzG/P0gulLkL5hUZzslf trevorjwhitney@gmail.com"
      # crostini
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL35ZOGslZ2AZ4ioRlHqOWD1gsviLeon4bXnkJ0IXzxh trevorjwhitney@gmail.com"
    ];
    shell = pkgs.zsh;
    hashedPassword = "$6$yk8kVONJVBtnD8i9$S0GR95lpXGOZ0cNLy.sZiaPuShpK/tgS9TjIcyvKqDKib9Fi5onZb6aPN9tj9zlMVhDQbvlHmb/YHTmiTZ0Ms1";
    uid = 1000;
  };
}
