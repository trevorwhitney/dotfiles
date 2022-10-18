{ config, pkgs, lib, ... }:
let
  inherit (pkgs) dotfiles secrets;
  cfg = config.i3;
in
{

  options = with lib; {
    i3 = {
      hostConfig = mkOption {
        description = "path to host specific i3 config file";
        type = types.path;
      };

      terminal = {
        command = mkOption {
          type = types.str;
          default = "${pkgs.kitty}/bin/kitty";
          description = ''
            Command to use to open a new terminal window
          '';
        };
      };
    };
  };

  config = {
    xdg.configFile."i3/scripts".source = "${dotfiles}/config/i3/scripts";

    xdg.configFile."i3/host.conf".source = "${cfg.hostConfig}";

    xdg.configFile."i3/config".text = ''
      # i3 config file (v4)
      #
      # Please see https://i3wm.org/docs/userguide.html for a complete reference!

      # Define names for default workspaces for which we configure key bindings later on.
      # We use variables to avoid repeating the names in multiple places.
      set $ws1 "1"
      set $ws2 "2"
      set $ws3 "3"
      set $ws4 "4"
      set $ws5 "5"
      set $ws6 "6"
      set $ws7 "7"
      set $ws8 "8"
      set $ws9 "9"
      set $ws10 "10"

      set $mod Mod4

      include ~/.config/i3/host.conf

      # Font for window titles. Will also be used by the bar unless a different font
      # is used in the bar {} block below.
      font pango:Ubuntu 14

      focus_follows_mouse no

      # Start XDG autostart .desktop files using dex. See also
      # https://wiki.archlinux.org/index.php/XDG_Autostart
      exec --no-startup-id dex --autostart --environment i3

      # To hide home and trash folder and desktop
      # gsettings set org.gnome.gnome-flashback.desktop.icons show-home false
      # gsettings set org.gnome.gnome-flashback.desktop.icons show-trash false
      # gsettings set org.gnome.gnome-flashback desktop false

      # Use Mouse+$mod to drag floating windows to their wanted position
      floating_modifier $mod

      # start a terminal
      # bindsym $mod+Return exec i3-sensible-terminal
      bindsym $mod+Return exec ${cfg.terminal.command}

      # kill focused window
      # bindsym $mod+Shift+q kill
      bindsym $mod+q kill

      # A more modern dmenu replacement is rofi:
      bindsym $mod+d exec rofi  -no-config \
                                -no-lazy-grab \
                                -matching fuzzy \
                                -sorting-method fzf \
                                -sort \
                                -show drun \
                                -modi drun \
                                -theme $HOME/.config/polybar/scripts/rofi/kde_simplemenu.rasi

      # use rofi to provide alt+tab
      bindsym Mod1+Tab exec --no-startup-id rofi -no-config \
                                                 -no-lazy-grab \
                                                 -matching fuzzy \
                                                 -sorting-method fzf \
                                                 -sort \
                                                 -show window \
                                                 -modi window \
                                                 -theme $HOME/.config/polybar/scripts/rofi/kde_simplemenu.rasi

      # change focus
      bindsym $mod+h focus left
      bindsym $mod+j focus down
      bindsym $mod+k focus up
      bindsym $mod+l focus right

      bindsym $mod+bracketright focus next sibling
      bindsym $mod+bracketleft focus prev sibling

      # alternatively, you can use the cursor keys:
      bindsym $mod+Left focus left
      bindsym $mod+Down focus down
      bindsym $mod+Up focus up
      bindsym $mod+Right focus right

      # move focused window
      bindsym $mod+Shift+h move left
      bindsym $mod+Shift+j move down
      bindsym $mod+Shift+k move up
      bindsym $mod+Shift+l move right

      # alternatively, you can use the cursor keys:
      bindsym $mod+Shift+Left move left
      bindsym $mod+Shift+Down move down
      bindsym $mod+Shift+Up move up
      bindsym $mod+Shift+Right move right

      # split in horizontal orientation
      bindsym $mod+v split h

      # split in vertical orientation
      bindsym $mod+x split v

      # enter fullscreen mode for the focused container
      bindsym $mod+f fullscreen toggle

      # change container layout (stacked, tabbed, toggle split)
      bindsym $mod+s layout stacking
      bindsym $mod+w layout toggle tabbed split
      bindsym $mod+e layout toggle splitv splith

      # toggle tiling / floating
      bindsym $mod+Shift+space floating toggle

      # change focus between tiling / floating windows
      bindsym $mod+space focus mode_toggle

      # focus the parent container
      bindsym $mod+a focus parent

      # focus the child container
      bindsym $mod+c focus child

      # switch to workspace
      bindsym $mod+1 workspace number $ws1
      bindsym $mod+2 workspace number $ws2
      bindsym $mod+3 workspace number $ws3
      bindsym $mod+4 workspace number $ws4
      bindsym $mod+5 workspace number $ws5
      bindsym $mod+6 workspace number $ws6
      bindsym $mod+7 workspace number $ws7
      bindsym $mod+8 workspace number $ws8
      bindsym $mod+9 workspace number $ws9
      bindsym $mod+0 workspace number $ws10

      # move focused container to workspace
      bindsym $mod+Shift+1 move container to workspace number $ws1
      bindsym $mod+Shift+2 move container to workspace number $ws2
      bindsym $mod+Shift+3 move container to workspace number $ws3
      bindsym $mod+Shift+4 move container to workspace number $ws4
      bindsym $mod+Shift+5 move container to workspace number $ws5
      bindsym $mod+Shift+6 move container to workspace number $ws6

      # primary workspaces accessed with right hand
      bindsym $mod+Shift+7 move container to workspace number $ws7
      bindsym $mod+Shift+8 move container to workspace number $ws8
      bindsym $mod+Shift+9 move container to workspace number $ws9
      bindsym $mod+Shift+0 move container to workspace number $ws10

      bindsym $mod+less move workspace to output down
      bindsym $mod+greater move workspace to output up

      bindsym $mod+n workspace next
      bindsym $mod+p workspace prev

      for_window [all] title_window_icon yes

      for_window [class="Spotify"] move to workspace $ws1
      for_window [class="1Password"] move to workspace $ws1
      # example floating window exception
      # for_window [class="Gnome-tweaks"] floating enable

      # reload the configuration file
      bindsym $mod+Shift+c reload
      # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
      bindsym $mod+Shift+r restart
      # exit i3 (logs you out of your X session)
      bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'xfce4-session-logout'"

      # resize window (you can also use the mouse for that)
      mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym h resize shrink width 5 px or 5 ppt
        bindsym j resize grow height 5 px or 5 ppt
        bindsym k resize shrink height 5 px or 5 ppt
        bindsym l resize grow width 5 px or 5 ppt

        bindsym Shift+h resize shrink width 1 px or 1 ppt
        bindsym Shift+j resize grow height 1 px or 1 ppt
        bindsym Shift+k resize shrink height 1 px or 1 ppt
        bindsym Shift+l resize grow width 1 px or 1 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 5 px or 5 ppt
        bindsym Down resize grow height 5 px or 5 ppt
        bindsym Up resize shrink height 5 px or 5 ppt
        bindsym Right resize grow width 5 px or 5 ppt

        bindsym Shift+Left resize shrink width 1 px or 1 ppt
        bindsym Shift+Down resize grow height 1 px or 1 ppt
        bindsym Shift+Up resize shrink height 1 px or 1 ppt
        bindsym Shift+Right resize grow width 1 px or 1 ppt

        # back to normal: Enter or Escape or $mod+r
        bindsym Return mode "default"
        bindsym Escape mode "default"
        bindsym $mod+r mode "default"
      }

      bindsym $mod+r mode "resize"

      # media controls
      # <F4> play/pause spotify
      bindcode $mod+70 exec "playerctl --player=spotify play-pause"
      # <F5> pervious
      bindcode $mod+71 exec "playerctl --player=spotify previous"
      # <F6> next
      bindcode $mod+72 exec "playerctl --player=spotify next"

      # gaps
      for_window [class=".*"] border pixel 5

      gaps inner 7
      # outer gaps are added to inner
      gaps outer 3

      # Only enable gaps on a workspace when there is at least one container
      smart_gaps on
      # smart_borders on

      # for use with i3-msg
      # gaps inner|outer|horizontal|vertical|top|right|bottom|left current|all set|plus|minus|toggle <px>

      # colors
      set $base03 #002b36
      set $base02 #073642
      set $base01 #586e75
      set $base00 #657b83
      set $base0 #839496
      set $base1 #93a1a1
      set $base2 #eee8d5
      set $base3 #fdf6e3

      set $yellow #b58900
      set $orange #cb4b16
      set $red #dc322f
      set $magenta #d33682
      set $violet #6c71c4
      set $blue #268bd2
      set $cyan #2aa198
      set $green #859900

      # Basic color configuration using the Base16 variables for windows and borders.
      # Property Name         Border   BG       Text      Indicator  Child Border
      client.focused          $blue    $base3   $blue     $violet    $blue
      client.focused_inactive $blue    $base3   $blue     $violet    $base02
      client.unfocused        $base02  $base02  $base1    $violet    $base02
      client.urgent           $yellow  $yellow  $base02   $yellow    $yellow
      client.placeholder      $base3   $base2   $base3    $base1     $base2
      client.background       $base02

      # Polybar
      # Polybar launch script (located ~/.config/polybar/launch.sh) 
      exec_always --no-startup-id $HOME/.config/polybar/launch.sh

      # NetworkManager is the most popular way to manage wireless networks on Linux,
      # and nm-applet is a desktop environment-independent system tray GUI for it.
      exec_always --no-startup-id bash -e $HOME/.config/i3/scripts/nm-applet.sh

      # Start dropbox so it's tray icon is available
      # may require: dropbox autostart n
      # TODO: is this working consistently?
      exec --no-startup-id dbus-launch dropbox start

      # Start clipit so try icon is available
      exec --no-startup-id dbus-launch ${pkgs.copyq}/bin/copyq

      # Diodon clipboard manager
      # exec_always --no-startup-id $HOME/.config/i3/scripts/diodon.sh
      # bindsym Mod1+Shift+v exec --no-startup-id /usr/bin/diodon

      # Rofi
      bindsym $mod+Shift+p exec --no-startup-id ~/.config/polybar/scripts/powermenu.sh

      # Gnome
      bindsym $mod+z exec --no-startup-id gnome-control-center

      # Lock screen
      bindsym $mod+Escape exec --no-startup-id dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock

    '';

    # i3 config assumes dropbox and nm-applet are on path
    home.packages = with pkgs; [ dropbox networkmanagerapplet rofi i3-gaps ];

    dconf = {
      enable = true;
      settings = {
        "org/gnome/gnome-flashback" = {
          desktop = false;
          root-background = true;
        };
        "org/gnome/gnome-flashback/desktop/icons" = {
          show-home = false;
          show-trash = false;
        };
      };
    };
  };
}
