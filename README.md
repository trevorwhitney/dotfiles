# Dotfiles

This repo contains my dotfiles for setting up a new computer.

## Installation

`./install [host]`

### Starting Tailscale

For exit nodes:

* `tailscale up --advertise-exit-node --advertise-routes=10.11.0.0/24 --operator=twhitney --hostname=cerebral`

For other nodes

* `tailscale up --operator=twhitney`

## Tmux

* Use `<C-j>` and friends to move between vim panes and tmux panes.
* `<C-a>` is a lot easier for me to type than `<C-b>`. The tmux bind key
  for this configuration is `<C-a>`. To get a real `<C-a>`, say to increment
  a value in vim, use `<C-a>a`.
* On OSX hold down the 'Option' key to select text with the mouse

### Tmux Tricks

Because I keep forgetting them

* Redistrubte panes Vertically
  `select-layout even-vertical`
  Usually assigned to: Ctrl+b, Alt+2

* Redistrubte panes Horizontally
  `select-layout even-horizontal`
  Usually assigned to: Ctrl+b, Alt+1

## Nix

When creating a local package, the following command is useful:

```bash
nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'
```

## TODO

* template `~/.config/spotifyd/spotifyd.conf` and `~/.conifg/spotify-tui/config.yaml` and move to desktop unit
