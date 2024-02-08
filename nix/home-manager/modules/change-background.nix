{ pkgs, ... }:
let
  change-background = pkgs.writeShellApplication {
    name = "change-background";

    runtimeInputs = with pkgs; [ kitty tmux ];

    text = ''
          function everforest_light() {
            kitten themes --reload-in=all "Everforest Light Soft"
            tmux set-environment -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE "fg=#5c6a72,bg=#f3ead3"
          }

          function everforest_dark() {
            kitten themes --reload-in=all "Everforest Dark Soft"
            tmux set-environment -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE "fg=#d3c6aa,bg=#333c43"

          }

          function solarized_light() {
            kitten themes --reload-in=all "Solarized Light"
            tmux set-environment -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE "fg=#586e75,bg=#002b36"

          }

          function solarized_dark() {
            kitten themes --reload-in=all "Solarized Dark"
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
              everforest_dark
              ;;
            *)
              tmux set-environment -g BAT_THEME "Solarized (light)"
              tmux set-environment -g FZF_PREVIEW_PREVIEW_BAT_THEME "Solarized (light)"
              everforest_light
              ;;
            esac
          }

      change_background "''$@"
    '';
  };
in
{
  home.packages = [
    change-background
  ];
}
