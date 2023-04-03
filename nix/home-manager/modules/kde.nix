{ config, pkgs, lib, ... }: {
  programs.firefox =
    {
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        cfg = {
          enableTridactylNative = true;
          enablePlasmaBrowserIntegration = true;
        };
      };

    };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    xorg.xfd
    xdg-desktop-portal

    dejavu_fonts
    emote
    fontconfig
    roboto
    siji

    (nerdfonts.override {
      fonts = [
        "CascadiaCode"
        "DroidSansMono"
        "FantasqueSansMono"
        "FiraCode"
        "Hack"
        /* Iosevka is failing to download */
        /* "Iosevka" */
        "JetBrainsMono"
        "Noto"
        "Terminus"
        "Ubuntu"
        "UbuntuMono"
        "VictorMono"
      ];
    })
  ];

  xdg.configFile."plasma-workspace/env/ssh-agent-startup.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      export SSH_ASKPASS="/usr/bin/ksshaskpass"

      if ! pgrep -u $USER ssh-agent > /dev/null; then
          ssh-agent > ~/.ssh-agent-info
      fi
      if [[ "$SSH_AGENT_PID" == "" ]]; then
          eval $(<~/.ssh-agent-info)
      fi
    '';
  };

  xdg.configFile."plasma-workspace/env/ssh-agent-shutdown.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      [ -z "$SSH_AGENT_PID" ] || eval "$(ssh-agent -k)"
    '';
  };
}
