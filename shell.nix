{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ nix home-manager git zsh ];
  buildInputs = with pkgs; [
    deploy-rs.deploy-rs
    libvirt
    mkpasswd
    virt-manager
    qemu
  ];

  packages = with pkgs; [
    (neovim.override {
      withLspSupport = true;
      nodePkg = nodejs;
      goPkg = go;
    })
  ];
}
