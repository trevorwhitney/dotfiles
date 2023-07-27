final: prev: {
  kolide = import ../packages/kolide {
    inherit (prev) stdenv pkgs lib;
  };
}
