{ pkgs, config, ... }:
let
  change-background = pkgs.change-background;
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
    light = "${change-background}/bin/change-background light && exec zsh";
    dark = "${change-background}/bin/change-background dark && exec zsh";
  };
}
