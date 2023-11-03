{ pkgs
, home-manager
, username
, imports ? [ ]
, config ? { }
, ...
}:
let
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
          home.packages = with pkgs; [
            xsel
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
