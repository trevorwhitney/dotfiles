{ pkgs, lib, config, ... }: {
  users.users.vagrant = {
    isNormalUser = true;
    group = "users";
    shell = pkgs.zsh;
    hashedPassword = "$6$yk8kVONJVBtnD8i9$S0GR95lpXGOZ0cNLy.sZiaPuShpK/tgS9TjIcyvKqDKib9Fi5onZb6aPN9tj9zlMVhDQbvlHmb/YHTmiTZ0Ms1";
    uid = 1000;
    openssh.authorizedKeys.keys = [
      # cerebral
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObaPLIJ0t6iar5DTKRmKCQmFzG/P0gulLkL5hUZzslf trevorjwhitney@gmail.com"
    ];
  };

  programs.zsh.enable = true;

}
