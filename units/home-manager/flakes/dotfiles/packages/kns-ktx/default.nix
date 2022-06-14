{ lib, runCommand }:

runCommand "dotfiles" { src = ./src; } "cp -r $src $out"

