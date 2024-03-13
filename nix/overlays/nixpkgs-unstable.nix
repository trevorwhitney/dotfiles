{ pkgs }:

final: prev: rec {
  inherit (pkgs)
    # kitty
    kitty
    kitty-themes

    #k9s
    k9s

    # neovim
    neovim-unwrapped

    # not in stable yet
    nixd
    prettierd

    # GUI apps that I'd like to be on the latest version of
    _1password-gui
    gimp
    spotify
    thunderbird

    #tmux
    tmux

    # latest go version
    go_1_21
    go_1_22
    delve;
}
