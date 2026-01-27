{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoc-gen-gogoslick";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "gogo";
    repo = "protobuf";
    rev = "v${version}";
    sha256 = "sha256-CoUqgLFnLNCS9OxKFS7XwjE17SlH6iL1Kgv+0uEK2zU=";
  };

  vendorHash = "sha256-nOL2Ulo9VlOHAqJgZuHl7fGjz/WFAaWPdemplbQWcak=";

  subPackages = [ "protoc-gen-gogoslick" ];

  meta = with lib; {
    description = "protoc-gen-gogoslick is same as gogofaster, but with generated string, gostring and equal methods, and imports gogoprotobuf, a fork of golang/protobuf with extra code generation features.";
    homepage = "https://github.com/gogo/protobuf";
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
