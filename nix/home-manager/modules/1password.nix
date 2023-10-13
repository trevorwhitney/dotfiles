{ pkgs, config, lib, ... }:
let
  cfg = config.programs._1password;
in
{
  options = {
    programs._1password = {
      userSystemdUnit.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "whether to enable the user systemd unit";
      };
      autostartDesktopFile.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "whether to create the desktop file under ~/.config/autostart";
      };
    };

  };
  config = {
    home.packages = with pkgs; [
      _1password
      _1password-gui
    ];

    # Automatcially start 1password
    xdg.configFile."autostart/1password.desktop" = lib.mkIf cfg.autostartDesktopFile.enable {
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

    systemd.user.services._1password = lib.mkIf cfg.userSystemdUnit.enable {
      Unit = {
        Description = "1Password password manager";
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs._1password-gui}/bin/1password --silent %U";
      };

      Install = { WantedBy = [ "default.target" ]; };
    };

    # use 1password ssh key for signing commits
    # if I go back to GPG signing I'll have to remove this
    programs.git.extraConfig = {
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObaPLIJ0t6iar5DTKRmKCQmFzG/P0gulLkL5hUZzslf";
      gpg.format = "ssh";
      # this doesn't work when forwarding agent of ssh
      # gpg.ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      commit.gpgsign = true;
    };

    # use 1password ssh agent
    programs.ssh = {
      enable = true;
      # use the 1password ssh agent
      extraConfig = ''
        IdentityAgent ~/.1password/agent.sock
        ForwardAgent yes
      '';
    };

    programs.zsh.use1Password = true;
  };
}
