{ pkgs, lib, buildGoModule, fetchFromGitHub }:

buildGoModule.override {
 go = pkgs.go_1_21;
} rec {
  pname = "pex";
  version = "69e65b77f500d372e6b76ddc85d75edfb093a92c";

  src = fetchFromGitHub {
    owner = "josharian";
    repo = "pex";
    rev = "${version}";
    sha256 = "3JYBXvmegq5YpPMZi9y6rruldus18Lmmjayx6nyouqQ=";
  };

  vendorSha256 = "IXthluHhbubXR1W3zXTipE3M4+4cUyhr/MhS664nVJo=";

  meta = with lib; {
    homepage = "https://github.com/josharian/pex";
    license = licenses.bsd3;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
