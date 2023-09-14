{ pkgs, ... }: {
  home.packages = with pkgs; [
    _1password
    _1password-gui
  ];

  # Automatcially start 1password
  xdg.configFile."autostart/1password" = {
    executable = true;
    text = ''
      [Desktop Entry]
      Name=1Password
      Exec=${pkgs._1password-gui}/bin/1password --silent %U
      Terminal=false
      Type=Application
      Icon=1password
      StartupWMClass=1Password
      Comment=Password manager and secure wallet
      MimeType=x-scheme-handler/onepassword;
      Categories=Office;
    '';
  };

  # use 1password ssh key for signing commits
  # if I go back to GPG signing I'll have to remove this
  programs.git.extraConfig = {
    user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObaPLIJ0t6iar5DTKRmKCQmFzG/P0gulLkL5hUZzslf";
    gpg.format = "ssh";
    gpg.ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
    commit.gpgsign = true;
  };

  # use 1password ssh agent
  programs.ssh = {
    enable = true;
    # use the 1password ssh agent
    extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
    '';
  };
}
