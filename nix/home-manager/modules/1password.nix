{ pkgs, config, lib, ... }:
let
  cfg = config.programs._1password;
in
{
  options = {
    programs._1password = {
      host = {
        darwin = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "set to true on darwin hosts to avoid some linux specific stuff";

        };
      };
      userSystemdUnit.enable = lib.mkOption {
        type = lib.types.bool;
        default = !cfg.host.darwin;
        description = "whether to enable the user systemd unit";
      };
      autostartDesktopFile.enable = lib.mkOption {
        type = lib.types.bool;
        default = !cfg.host.darwin;
        description = "whether to create the desktop file under ~/.config/autostart";
      };
      useNixPkgs = lib.mkOption {
        type = lib.types.bool;
        default = !cfg.host.darwin;
        description = "whether to install 1pssword via nix packages. Disable if installd elsewhere";
      };
    };

  };
  config = {
    home.packages = lib.mkIf cfg.useNixPkgs (with pkgs; [
      _1password
      _1password-gui
    ]);

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
        Restart = "always";
        RestartSec = 5;
      };

      Install = { WantedBy = [ "default.target" ]; };
    };

    programs = {
      # use 1password ssh key for signing commits
      git.settings.extraConfig = {
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObaPLIJ0t6iar5DTKRmKCQmFzG/P0gulLkL5hUZzslf";
        gpg.format = "ssh";
        commit.gpgsign = true;
      };

      # use 1password ssh agent
      ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          jerry = {
            forwardAgent = false;
            user = "twhitney";
            hostname = "10.11.0.52";
          };
          mickey = {
            forwardAgent = true;
            user = "twhitney";
            hostname = "10.11.0.74";
          };
          monterey = {
            forwardAgent = false;
            user = "twhitney";
            hostname = "10.11.0.51";
          };
          omada = {
            forwardAgent = true;
            hostname = "10.11.0.72";
          };
          proxmox = {
            forwardAgent = true;
            user = "twhitney";
            hostname = "10.11.0.100";
          };
        };
      };

      zsh.use1Password = true;
    };
  };
}
