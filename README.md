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

# Development Environments

These are docker images I use for various dev environments

## Notes

To build a docker image, `cd` into correct directory, and run `docker build -t tag-name .`
To interactively update a docker image, `docker run -it image-name`, make your changes, then:
```
# docker ps -a
# docker commit SHA image-name
```

To publish a docker image:
```
docker tag SHA IMAGE_NAME:latest
docker push IMAGE_NAME
```

Adding a non-root user to docker:
```
sudo groupadd docker
sudo usermod -aG docker $(whoami)
sudo service docker restart
```

## Haskell
Summary
In summary adding these plugins and lines to the .vimrc will introduce several Haskell specific commands which are bound to these keyboard shortcuts:

Command
`t + w` Insert type for toplevel declaration
`t + q` Query type of expression under cursor
`t + s` Case split expression under cursor
`t + e` Erase type query
`Ctrl + x + o` Tab complete under cursor

Don't have implemented yet
`a + =` Align on equal sign
`a + -` Align on case match
`\ + c + SpaceToggle` comment of text under cursor
`\ + c + s` Toggle “sexy” comment of text
