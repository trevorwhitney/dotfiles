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
    sha256 = "sha256-KjjUlemlf7CC9gWc/USE7eu7QMpK8fGBu5e1u2r2jmo=";
  };

  vendorHash = null;

  subPackages = [ "protoc-gen-gogoslick" ];

  meta = with lib; {
    description = "protoc-gen-gogoslick is same as gogofaster, but with generated string, gostring and equal methods, and imports gogoprotobuf, a fork of golang/protobuf with extra code generation features.";
    homepage = "https://github.com/gogo/protobuf";
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
