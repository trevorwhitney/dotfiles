{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xk6";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "xk6";
    rev = "v${version}";
    sha256 = "06bjrm5hg2nx7cjg5w201z8bqcl3i28355ssy36mx897mgrm0d59";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Custom k6 Builder";
    homepage = "https://github.com/grafana/xk6";
    license = licenses.asl20;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
