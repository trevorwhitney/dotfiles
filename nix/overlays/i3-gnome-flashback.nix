final: prev: {
  i3-gnome-flashback =
    prev.callPackage ../packages/i3-gnome-flashback { inherit (prev) runCommand; };
}
