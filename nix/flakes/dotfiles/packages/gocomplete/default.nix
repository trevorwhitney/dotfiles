{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gocomplete";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "posener";
    repo = "complete";
    rev = "v${version}";
    sha256 = "0nri6hkfb0z3dkxf2fsfidr4bxbn91rjsqhg5s0c2jplf0aclppz";
  };

  vendorSha256 = "04n7654vb8qmdqxn571ad7w384zxhbbb0bprpcz5g94dbx72h57f";

  subPackages = [ "gocomplete" ];

  meta = with lib; {
    description = "Everything for bash completion and Go";
    homepage = "https://github.com/posener/complete";
    license = licenses.mit;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
