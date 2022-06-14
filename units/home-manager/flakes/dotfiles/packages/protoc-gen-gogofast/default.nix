{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-gogofast";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "gogo";
    repo = "protobuf";
    rev = "v${version}";
    sha256 = "0dfv1bhx5zhb5bsj5sj757nkacf2swp1ajpcyj9d0b37n602m18a";
  };

  vendorSha256 = "1abi2ss9bag9fn7sa0c5yp7s7wgdwphncq520a3m6mixb99gdqlw";

  subPackages = [ "protoc-gen-gogofast" ];

  meta = with lib; {
    description = "protoc-gen-gogofast is the same as gofast, but imports gogoprotobuf, a fork of golang/protobuf with extra code generation features.";
    homepage = "https://github.com/gogo/protobuf";
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
