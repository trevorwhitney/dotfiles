{ secrets, loki }: final: prev: {
  deployment-tools = import ../packages/deployment-tools {
    inherit secrets loki;
    inherit (final) stdenv pkgs lib;
  };
}
