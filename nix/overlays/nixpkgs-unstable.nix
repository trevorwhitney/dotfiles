{ pkgs }:
final: prev: {
  inherit (pkgs)
    firefox-beta-bin-unwrapped
    firefox-bin-unwrapped
    firefox-unwrapped
    lua-language-server;
}
