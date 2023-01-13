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
  "twhitney@penguin" = home-manager.lib.homeManagerConfiguration
    (baseConfig // {
      inherit pkgs;
      system = "x86_64-linux";
      configuration = config // {
        imports = [
          ./modules/tmux.nix
          {
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

            systemd.user = {
              services.ssh-agent = {
                Install.WantedBy = [ "default.target" ];
                Unit.Description = "SSH key agent";
                Service = {
                  Type = "simple";
                  Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
                  ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
                };
              };
              sessionVariables = {
                SSH_AUTH_SOCK = ''''${XDG_RUNTIME_DIR}/ssh-agent.socket'';
              };
            };
          }
        ] ++ imports;
      };
    });
}
