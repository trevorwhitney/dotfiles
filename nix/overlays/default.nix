self: super:
let
  overlays = [
    ./change-background.nix
    ./dotfiles.nix
    ./golang-perf.nix
    ./i3-gnome-flashback.nix
    ./inshellisense.nix
    ./jdtls.nix
    ./pex.nix
  ];
in
with super.lib; (foldl' (flip extends) (_: super)
  (map import overlays)
  self
)
