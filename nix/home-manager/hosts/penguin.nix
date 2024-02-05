{ pkgs
, home-manager
, username
, imports ? [ ]
, config ? { }
, ...
}:
let
  imports = [
    ./modules/bash.nix
    ./modules/linux.nix
    ./modules/fonts.nix
    ./modules/git.nix
    ./modules/neovim.nix
    ./modules/tmux.nix
    ./modules/xdg.nix
    ./modules/zsh.nix
  ];

  baseConfig = {
    home = {
      inherit username;
      homeDirectory = "/home/${username}";
      stateVersion = "21.11";
    };
  };
in
{
  "twhitney@penguin" = home-manager.lib.homeManagerConfiguration
    {
      inherit pkgs;
      modules = [
        baseConfig
        config
        ../modules/tmux.nix
        ../modules/1password.nix
        {
  	  targets.genericLinux.enable = true;
          services.dropbox.enable = true;
  	  xdg.configFile."yamllint/config".source = "${pkgs.dotfiles}/yamllint.yaml";

          home.packages = with pkgs; [
            xsel
            lm_sensors
      	    sysstat
          ];
          programs.neovim = {
            withLspSupport = false;
          };
          programs.zsh = {
            sessionVariables = {
              GPG_TTY = "$(tty)";
            };

            shellAliases = {
              mosh-cerebral = ''
                mosh --server ~/.nix-profile/bin/mosh-server twhitney@cerebral.trevorwhitney.net
              '';
            };
          };
          programs._1password = {
            userSystemdUnit.enable = true;
            autostartDesktopFile.enable = false;
          };
        }
      ] ++ imports;
    };
}
