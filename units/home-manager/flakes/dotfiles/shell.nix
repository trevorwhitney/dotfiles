{ pkgs ? import <nixpkgs> }:

with pkgs;
mkShell {
  buildInputs = [
    nix-prefetch
    dotfiles
    git-template
    gocomplete
    gotools
    jdtls
    jsonnet
    jsonnet-language-server
    jsonnet-lint
    jsonnetfmt
    kns-ktx
    mosh
    oh-my-zsh-custom
    protoc-gen-gogofast
    protoc-gen-gogoslick
    xk6
  ];
}
