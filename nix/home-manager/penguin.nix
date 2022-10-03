{ pkgs
, system
, home-manager
, username
, imports ? [ ]
, config ? { }
, ...
}:
let
  inherit (import ./common.nix { inherit pkgs; }) nixGLWrapWithName nixGLWrap;
  baseConfig = {
    inherit username;
    homeDirectory = "/home/${username}";
  };
in
{
  "twhitney@penguin" = home-manager.lib.homeManagerConfiguration
    (baseConfig // {
      inherit pkgs;
      system = "x86_64-linux";
      configuration = config // {
        imports = [
          ./nix/home-manager/tmux.nix
          {
            programs.neovim = {
              withLspSupport = false;
            };
          }
        ] ++ imports;

        programs.zsh.sessionVariables = {
          GPG_TTY = "$(tty)";
        };
      };
    });
}
