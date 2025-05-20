{ pkgs, lib, config, ... }: {
  nix.settings.trusted-users = [ "twhitney" ];

  system.primaryUser = "twhitney";

  users.users.twhitney = {
    description = "Trevor Whitney";
    home = "/Users/twhitney";
    openssh.authorizedKeys.keys = [
      # cerebral
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObaPLIJ0t6iar5DTKRmKCQmFzG/P0gulLkL5hUZzslf trevorjwhitney@gmail.com"
      # crostini
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL35ZOGslZ2AZ4ioRlHqOWD1gsviLeon4bXnkJ0IXzxh trevorjwhitney@gmail.com"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
