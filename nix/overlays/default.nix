self: super:
let
  overlays = [
    ./dotfiles.nix
    ./golang-perf.nix
    ./i3-gnome-flashback.nix
    ./inshellisense.nix
    ./pex.nix
    ./jdtls.nix
    ./change-background.nix
  ];
in
with super.lib; (foldl' (flip extends) (_: super)
  (map import overlays)
  self
)
