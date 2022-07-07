{ lib, runCommand }:

runCommand "oh-my-zsh-custom" { src = ./src; } "cp -r $src $out"

