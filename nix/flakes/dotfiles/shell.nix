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

    # python with extra packages needed for scripts
    (
      let
        extra-python-packages = python-packages:
          with python-packages; [
            click
            dbus-python
            i3ipc
            pydbus
            pygobject3
            speedtest-cli
          ];
        python-with-packages = python38.withPackages extra-python-packages;
      in
      python-with-packages
    )
  ];
}
