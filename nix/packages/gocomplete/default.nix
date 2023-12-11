{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gocomplete";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "posener";
    repo = "complete";
    rev = "v${version}";
    sha256 = "0nri6hkfb0z3dkxf2fsfidr4bxbn91rjsqhg5s0c2jplf0aclppz";
  };

  vendorHash = "sha256-7hQoTl+NpFc+u/kusNaC/RM0+GkqnGI7bhWjtUkxxxI=";

  subPackages = [ "gocomplete" ];

  meta = with lib; {
    description = "Everything for bash completion and Go";
    homepage = "https://github.com/posener/complete";
    license = licenses.mit;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
