{ pkgs
, system
, home-manager
, username
, imports ? [ ]
, config ? { }
, ...
}:
let
  baseConfig = {
    inherit username;
    homeDirectory = "/home/${username}";
  };
in
{
  "twhitney@kolide" = home-manager.lib.homeManagerConfiguration
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
