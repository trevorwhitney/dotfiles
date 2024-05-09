{ secrets }: final: prev: {
  deployment-tools = import ../packages/deployment-tools {
    inherit secrets;
    inherit (final) stdenv pkgs lib;
  };
}
