{ pkgs, ... }: pkgs.writeShellApplication {
  name = "change-background";

  runtimeInputs = with pkgs; [ tmux ];

  text = ''
    function change_background() {
      local mode_setting="''${1}"
      local mode="light"

      if [[ ''${#} -eq 0 ]]; then
        if defaults read -g AppleInterfaceStyle; then
          mode="dark"
        fi
      else
        case ''${mode_setting} in
        dark)
          osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = true" >/dev/null
          mode="dark"
          ;;
        *)
          osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = false" >/dev/null
          mode="light"
          ;;
        esac
      fi

      for pid in ''$(pgrep vim); do kill -SIGUSR1 "''${pid}"; done

      tmux set-environment -g BACKGROUND "''${mode}"
      tmux source-file ~/.config/tmux/tmux.conf

      case "''${mode}" in
      dark)
        sed -i 's/everforest-light/everforest-dark/' "''${XDG_CONFIG_HOME}/k9s/config.yaml"
        ;;
      *)
        sed -i 's/everforest-dark/everforest-light/' "''${XDG_CONFIG_HOME}/k9s/config.yaml"
        ;;
      esac
    }

    change_background "''$@"
  '';
}
