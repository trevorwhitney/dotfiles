{ lib, runCommand }:

runCommand "git-template" { src = ./src; } "cp -r $src $out"

