{ pkgs, config, ... }:
let
  check-appearance = pkgs.writeTextFile {
    name = "checkAppearance.scpt";
    text = ''
      -- Check the current appearance (Light/Dark)
      tell application "System Events"
        tell appearance preferences
          set currentMode to (get dark mode)
        end tell
      end tell

      if currentMode is true then
        return "dark"
      else
        return "light"
      end if
    '';
  };

  change-background = pkgs.writeShellApplication {
    name = "change-background";

    runtimeInputs = with pkgs; [ tmux ];

    text = ''
                function everforest_light() {
                  #kitten themes --reload-in=all "Everforest Light Soft"
      		        tmux set-environment -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE "fg=#a6b0a0,bg=#f3ead3"
                }

                function everforest_dark() {
                  #kitten themes --reload-in=all "Everforest Dark Soft"
                  tmux set-environment -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE "fg=#9da9a0,bg=#333c43"

                }

                function solarized_light() {
                  #kitten themes --reload-in=all "Solarized Light"
                  tmux set-environment -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE "fg=#586e75,bg=#002b36"

                }

                function solarized_dark() {
                  #kitten themes --reload-in=all "Solarized Dark"
                  tmux set-environment -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE "fg=#586e75,bg=#002b36"
                }

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
                    tmux set-environment -g BAT_THEME "Solarized (dark)"
                    tmux set-environment -g FZF_PREVIEW_PREVIEW_BAT_THEME "Solarized (dark)"
                    sed -i 's/everforest-light/everforest-dark/' "''${XDG_CONFIG_HOME}/k9s/config.yaml"
                    everforest_dark
                    ;;
                  *)
                    tmux set-environment -g BAT_THEME "Solarized (light)"
                    tmux set-environment -g FZF_PREVIEW_PREVIEW_BAT_THEME "Solarized (light)"
                    sed -i 's/everforest-dark/everforest-light/' "''${XDG_CONFIG_HOME}/k9s/config.yaml"
                    everforest_light
                    ;;
                  esac
                }

            change_background "''$@"
    '';
  };

  monitor-appearance = pkgs.writeShellApplication {
    name = "monitor-appearance";
    text = ''
      # Path to the AppleScript file
      APPLESCRIPT_PATH="${check-appearance}"

      # Function to get the current appearance mode
      get_current_mode() {
          osascript $APPLESCRIPT_PATH
      }

      INITIAL=$(get_current_mode)
      ${change-background}/bin/change-background "$INITIAL"

      # Initialize previous mode
      PREV_MODE=''${INITIAL}

      while true; do
          # Get current mode
          CURRENT_MODE=$(get_current_mode)

          # Check if the mode has changed
          if [ "$CURRENT_MODE" != "$PREV_MODE" ]; then
              # Run your action here
              echo "$(date) changing from $PREV_MODE to $CURRENT_MODE"
              ${change-background}/bin/change-background "$CURRENT_MODE"

              # Update previous mode
              PREV_MODE=$CURRENT_MODE
          else
            echo "$(date) $PREV_MODE is still $CURRENT_MODE"
          fi

          # Sleep for a while before checking again
          sleep 5
      done

    '';
  };
in
{
  home.packages = [
    change-background
    monitor-appearance
  ];

  launchd.agents.monitor-appearance = {
    enable = true;
    config = {
      Program = "${monitor-appearance}/bin/monitor-appearance";
      RunAtLoad = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/monitor-appearance.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs//var/log/monitor-appearance.stderr.log";
    };
  };

  programs.zsh.shellAliases = {
    light = "${change-background}/bin/change-background light && source ~/.zshrc";
    dark = "${change-background}/bin/change-background dark && source ~/.zshrc";
  };
}
