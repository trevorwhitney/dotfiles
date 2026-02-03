{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = "stylua";
    rev = "v${version}";
    sha256 = "0siq4h8v3m4fvymdv1qysg4rzanqcxynbgsiwhyfasp1qgawc1vf";
  };

  cargoHash = "sha256-njZTD6O67v787Z1tJ7G0QzxJLhqU2sfpOVw6r4woE9s=";

  meta = with lib; {
    description = "An opinionated code formatter for Lua 5.1, Lua 5.2 and Luau, built using full-moon.";
    homepage = "https://github.com/JohnnyMorganz/StyLua";
    license = licenses.mpl20;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
