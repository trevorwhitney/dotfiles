self: super:
let
  overlays = [
    ./dotfiles.nix
    ./dynamic-dns-reporter.nix
    ./golang-perf.nix
    ./i3-gnome-flashback.nix
    ./inshellisense.nix
    ./kubectl.nix
    ./pex.nix
    ./jdtls.nix
  ];
in
with super.lib; (foldl' (flip extends) (_: super)
  (map import overlays)
  self
)
