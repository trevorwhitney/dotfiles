{ pkgs }:

final: prev: rec {
  inherit (pkgs)
    # kitty
    kitty
    kitty-themes

    # TODO: sumneko was renamed to just lua-language server. Remove after 23.05 and switch to using stable.
    lua-language-server

    # GUI apps that I'd like to be on the latest version of
    _1password-gui
    gimp
    google-chrome-beta
    slack
    spotify

    # Wayland screensharing fixed in latest Zoom
    zoom-us;
}
