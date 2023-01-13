{ pkgs
, system
, home-manager
, username
, imports ? [ ]
, config ? { }
, ...
}:
let
  inherit (import ../modules/nixgl-wrap.nix { inherit pkgs; }) nixGLWrapWithName nixGLWrap;
  baseConfig = {
    inherit username;
    homeDirectory = "/home/${username}";
  };
in
{
  "twhitney@newImage" = home-manager.lib.homeManagerConfiguration
    (baseConfig // {
      inherit pkgs;
      system = "x86_64-linux";
      configuration = config // {
        imports = [{
          programs.neovim = {
            withLspSupport = true;
          };
        }] ++ imports;

        programs.zsh.sessionVariables = { GPG_TTY = "$(tty)"; };
      };
    });
}
