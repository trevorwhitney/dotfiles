# Dotfiles

This repo contains my dotfiles for setting up a new computer.

# Installation

`./install [host]`

# Bash tricks

## Tmux Integration

* Use `<C-j>` and friends to move between vim panes and tmux panes.
* `<C-a>` is a lot easier for me to type than `<C-b>`. The tmux bind key
  for this configuration is `<C-a>`. To get a real `<C-a>`, say to increment
  a value in vim, use `<C-a>a`.
* On OSX hold down the 'Option' key to select text with the mouse

### Tmux Trics

Because I keep forgetting them

* Redistrubte panes Vertically
  `select-layout even-vertical`
  Usually assigned to: Ctrl+b, Alt+2

* Redistrubte panes Horizontally
  `select-layout even-horizontal`
  Usually assigned to: Ctrl+b, Alt+1

## TODO:
  - move more stuff into home-manager
    - dotfiles
  - promote home-manager to top level?
   - does the host file need an entry for the home-manager file to use?
