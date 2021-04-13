# Dotfiles

This repo contains my dotfiles for setting up a new computer.

# Installation

`./install`

# Bash tricks

## Edit a previous command

1. Find the command using history
2. Hit `CTRL+X CTRL+E` to bring up the command in `$EDITOR`, which should be vim
3. Command will run if vim exits with 0 exit code, you can kill it with a non-zero
exit code by running `:cquit`

This can also be acheived by using the `fc` command, which can take a number from the
print out of the `history` command.

## Command Line Fu

* `!$` -> Last argument to previous command
* `!^` -> First argument to previous command
* `<()` -> Process substitution, put result of command in tmp file, pass tmp file as arg to outer command
* `$()` -> Use result of command as value

# Vim tricks

Because I keep forgetting them from not enough usage

## Project wide search and replace
```
:Ag findme
:Qargs | argdo %s/findme/replacement/gc | update
```

This can be used with [Subvert](https://github.com/tpope/vim-abolish#substitution) as well.

## Copy and Paste

To copy to, or paste from, the system clipboard, use the `*` register. The `+` register
is related to X11 CLIPBOARD, I have yet been able to grok the difference between `*` and
`+`.

Normally, `:set paste` before pasting in insert mode, and `:set nopaste` when done.
Otherwise autoident really screws things up. However, this should happen automatically
when pasting in insert mode in this configuration.

## Changing a word at multiple positions

Use the `gn` text object, which goes to the next occurance of the last thing you searched
for:
  1. Search for a word.
  1. Type `cgn`, then make the change on the next occurance.
  1. The `.` operator will now make your change on the next occurance.

## Use the global command

Global lets you run a command over the whole file. For example, if you want to apply
the macro recorded to `m` to all files that match a pattern, you can do the following:
```vimscript
:global/pattern/normal @m
```

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
