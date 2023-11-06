{ pkgs }:

final: prev: rec {
  inherit (pkgs)
    # kitty
    kitty
    kitty-themes

    # mosh, needed? @ 1.40 in 23.05
    # mosh

    # neovim
    neovim
    neovim-unwrapped

    # nixd not in stable yet
    nixd

    # GUI apps that I'd like to be on the latest version of
    _1password-gui
    gimp
    spotify
    thunderbird

    #tmux
    tmux

    # latest go version
    go_1_21;
}
