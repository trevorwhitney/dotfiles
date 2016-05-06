# Dotfile

This repo contains my dotfiles for setting up a new computer.

# Installation

The `install.sh` script will copy the dotfile into your home directory. The vim configuration requires vim 7.4 or higher.
If you're on a Mac, the `osx_install_vim.sh` script will help you get vim setup.

# Vim tricks

Because I keep forgetting them from not enough usage

## Project wide search and replace
```
:Ag findme
:Qargs | argdo %s/findme/replacement/gc | update
```

