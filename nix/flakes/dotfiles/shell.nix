{ pkgs ? import <nixpkgs> }:

with pkgs;
mkShell {
  buildInputs = [
    dotfiles
    git-template
    gocomplete
    jdtls
    jsonnet-language-server
    jsonnet-lint
    kns-ktx
    mosh
    nix-prefetch
    oh-my-zsh-custom
    protoc-gen-gogofast
    protoc-gen-gogoslick
    stylua
    xk6
  ];
}
