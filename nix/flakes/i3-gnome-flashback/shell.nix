{ pkgs ? import <nixpkgs> }:

with pkgs;
mkShell {
  buildInputs = [
    i3-gnome-flashback
    libglibutil
  ];
}
