{ pkgs }:

final: prev: rec {
  inherit (pkgs)
    # kitty
    kitty
    kitty-themes

    # neovim
    neovim
    neovim-unwrapped

    # GUI apps that I'd like to be on the latest version of
    _1password-gui
    gimp
    spotify
    thunderbird;
}
