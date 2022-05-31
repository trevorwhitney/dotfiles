{ pkgs ? import <nixpkgs> }:

with pkgs;
mkShell {
  buildInputs =
    [ glibcLocales nix-prefetch protobuf ncurses zlib openssl bash-completion ]
    ++ (with perlPackages; [ perl IOTty ]);
}
