# Dotfiles

![build status](https://circleci.com/gh/trevorwhitney/dotfiles.svg?style=shield&circle-token=3829835c1307815a3fb5ebe4755691cabaf0b9c4)

This repo contains my dotfiles for setting up a new computer.


# Installation

The `install.sh` script will copy the dotfile into your home directory. The vim configuration requires vim 7.4 or higher.
If you're on a Mac, the `osx_install_vim.sh` script will help you get vim setup.

## Local Configuration

The `.bash_profile` will source `~/.bash_profile.local` if it is present. An example local config is included in this repo.

# Bash tricks

## Edit a previous command

1. Find the command using history
2. Hit `CTRL+X``CTRL+E` to bring up the command in `$EDITOR`, which should be vim
3. Command will run if vim exits with 0 exit code, you can kill it with a non-zero
exit code by running `:cquit`

This can also be acheived by using the `fc` command, which can take a number from the
print out of the `history` command.

# Vim tricks

Because I keep forgetting them from not enough usage

## Keybindings Specific to this Configuration

These are the special keybindings I've added:

| Keybinding     | Action                                        | Required Plugin      |
| :------------- | :---------                                    | ---------------      |
| \<Leader\>sr   | Search and replace word under cursor          |                      |
| \<Leader\>ll   | Open location list                            |                      |
| \<Leader\>z    | Sort selection alphabetically                 |                      |
| \<Leader\>cs   | Run current spec file                         | vim-ruby             |
| \<Leader\>ns   | Run spec nearest to cursor                    | vim -ruby            |
| \<Leader\>ls   | Rerun most recently ran spec                  | vim-ruby             |
| \<Leader\>as   | Run all specs                                 | vim-ruby             |
| \<Leader\>rem  | Extract Ruby Method                           | vim-ruby-refactoring |
| \<Leader\>rriv | Rename ruby instance variable                 | vim-ruby-refactoring |
| \<Leader\>rrlv | Rename ruby local variable                    | vim-ruby-refactoring |
| \<Leader\>relv | Extract local ruby variable                   | vim-ruby-refactoring |
| \<Leader\>rec  | Extract ruby constant                         | vim-ruby-refactoring |
| \<Leader\>riv  | Introduce ruby variable                       | vim-ruby-refactoring |
| \<Leader\>rcpc | Convert ruby post conditional                 | vim-ruby-refactoring |
| \<Leader\>rel  | Extract ruby statement to let                 | vim-ruby-refactoring |
| \<Leader\>rit  | Inline temporary ruby variable                | vim-ruby-refactoring |
| \<Leader\>rapn | Add parameter to ruby method with no brackets | vim-ruby-refactoring |
| \<Leader\>rap  | Add parameter to ruby method with brackets    | vim-ruby-refactoring |
| \<Leader\>bv   | BufExplorerVerticalSplit                      | bufexplorer          |
| \<Leader\>bs   | BufExplorerHorizontalSplit                    | bufexplorer          |
| \<Leader\>bt   | ToggleBufExplorer                             | bufexplorer          |
| \<Leader\>be   | BufExplorer                                   | bufexplorer          |
| \<Leader\>n:   | Align selected code by :                      | tabular              |
| \<Leader\>n=   | Align selected code by =                      | tabular              |
| \<Leader\>p    | Open ctrl-p fuzzy search                      | ctrlp.vim            |
| \<Leader\>g    | Open Git Blame                                | fugitive.vim         |
| \<Leader\>d    | Search word under cursor in Dash              | dash.vim             |
| \<leader\>jI   | Add all missing java imports                  | vim-javacomplete2    |
| \<leader\>jR   | Remove all unused java importst               | vim-javacomplete2    |
| \<leader\>ji   | Smart add import for class under cursor       | vim-javacomplete2    |
| \<leader\>jii  | Dumb add import for class under cursor        | vim-javacomplete2    |
| \<C-j\>I       | Add all missing java imports                  | vim-javacomplete2    |
| \<C-j\>R       | Remove all unused java imports                | vim-javacomplete2    |
| \<C-j\>i       | Smart add import for class under cursor       | vim-javacomplete2    |
| \<C-j\>ii      | Dumb add import for class under cursor        | vim-javacomplete2    |
| \<leader\>jM   | Generate abstract Java methods                | vim-javacomplete2    |
| \<C-j\>jM      | Generate abstract Java methods                | vim-javacomplete2    |
| \<leader\>jA   | Generate Java accessor methods                | vim-javacomplete2    |
| \<leader\>js   | Generate Java setter                          | vim-javacomplete2    |
| \<leader\>jg   | Generate Java getter                          | vim-javacomplete2    |
| \<leader\>ja   | Generate Java setter and getter               | vim-javacomplete2    |
| \<leader\>jts  | Generate Java toString method                 | vim-javacomplete2    |
| \<leader\>jeq  | Generate Java equals and hashCode methods     | vim-javacomplete2    |
| \<leader\>jc   | Generate Java constructor                     | vim-javacomplete2    |
| \<leader\>jcc  | Generate defulat Java constructor             | vim-javacomplete2    |
| \<C-j\>s       | Generate Java setter                          | vim-javacomplete2    |
| \<C-j\>g       | Generate Java getter                          | vim-javacomplete2    |
| \<C-j\>a       | Generate Java setter and getter               | vim-javacomplete2    |
| \<leader\>=    | Neoformat current file                        | neoformat            |
| \<C-y\>,       | Emmet completion                              | emmet-vim            |

## Project wide search and replace
```
:Ag findme
:Qargs | argdo %s/findme/replacement/gc | update
```

## Paste

Remember to `:set paste` before pasting in insert mode, and `:set nopaste` when done.
Otherwise autoident really screws things up.

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

To install necessary Haskell binaries, run the following:

```bash
stack install hlint stylish-haskell hindent ghc-mod hdevtools fast-tags
```

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

## TODO

Investigate `envsubst` for templating/substitution.
  - For example, finding the stack bin path
  - Or OS specific stuff

Expand the home directory for the .gitignore_global path dynamically in installation
