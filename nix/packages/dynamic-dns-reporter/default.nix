{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dynamic-dns-reporter";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "trevorwhitney";
    repo = "dynamic-dns-reporter";
    rev = "96a1970120503563ea73501ac45377a13263345d";
    sha256 = "mQe312xvyINZNcnmSeTLRTahTWqIHoXvQmbRvU/tg54=";
  };

  vendorHash = "sha256-J1wDmI4TZDyhCOsxH4WMfST13mZkiurdUdy317P4PLY=";

  meta = with lib; {
    description = "A small utility to report your dynamic IP address to dnsimple";
    homepage = "https://github.com/trevorwhitney/dynamic-dns-reporter";
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
