{ pkgs }:

final: prev: rec {
  inherit (pkgs)
    # kitty
    kitty
    kitty-themes

    # neovim
    neovim
    neovim-unwrapped

    # nixd not in stable yet
    nixd

    # GUI apps that I'd like to be on the latest version of
    _1password-gui
    gimp
    spotify
    thunderbird;
}
