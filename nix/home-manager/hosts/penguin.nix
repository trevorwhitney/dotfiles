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

          systemd.user = with pkgs; {
            sessionVariables = {
              SSH_AUTH_SOCK = ''''${XDG_RUNTIME_DIR}/ssh-agent.socket'';
            };
            services.ssh-agent = {
              Install.WantedBy = [ "default.target" ];
              Unit.Description = "SSH key agent";
              Service = {
                Type = "simple";
                Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
                ExecStart = "${writers.writeBash "start-ssh-agent" ''
                    if ! pgrep -u $USER ssh-agent > /dev/null; then
                        ${pkgs.openssh}/bin/ssh-agent -D -a $SSH_AUTH_SOCK > ~/.ssh-agent-info
                        ssh-agent > ~/.ssh-agent-info
                    fi

                    if [[ "$SSH_AGENT_PID" == "" ]]; then
                        source ~/.ssh-agent-info
                    fi

                    # TODO: will likely need some sort of pinentry program to
                    # save the password in between boots
                    for KEY in $(ls $HOME/.ssh/id_ed25519* | grep -v \.pub); do
                      ssh-add -q ''${KEY} </dev/null
                    done
                  ''}";
                ExecStop = "${pkgs.writers.writeBash "stop-ssh-agent" ''
                    if pgrep -u $USER ssh-agent > /dev/null; then
                        source ~/.ssh-agent-info
                    fi

                    [ -z "$SSH_AGENT_PID" ] || eval "$(ssh-agent -k)"
                  ''}";
              };
            };
          };
        }
      ] ++ imports;
    };
}
