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
    jsonnet-language-server
    jsonnet-lint
    kns-ktx
    mosh
    oh-my-zsh-custom
    protoc-gen-gogofast
    protoc-gen-gogoslick
    xk6
  ];
}
