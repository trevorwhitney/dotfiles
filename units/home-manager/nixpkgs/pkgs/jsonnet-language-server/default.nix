{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jsonnet-language-server";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "jdbaldry";
    repo = "jsonnet-language-server";
    rev = "v${version}";
    sha256 = "1prm8qfarz97pjav4wv3rrh1461i4g4f4lvv17wa7fvjp1fg75k5";
  };

  vendorSha256 = "8jX2we1fpVmjhwcaLZ584MdbkvnrcDNAw9xKhT/z740=";

  meta = with lib; {
    description = "A Language Server Protocol server for jsonnet";
    homepage = "https://github.com/jdbaldry/jsonnet-language-server";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
