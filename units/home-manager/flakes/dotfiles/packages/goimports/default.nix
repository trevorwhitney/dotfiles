{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goimports";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "v${version}";
    sha256 = "1vpigdysgqw3086bd2372arjnq9i2fyss5f4l6p8z1kjy36qb1cc";
  };

  vendorSha256 = "UbQrjMv5x2zREeHDlIffri6PylE75vEwD9n0S3XyC8I=";

  subPackages = [ "cmd/goimports" ];

  meta = with lib; {
    description = "Command goimports updates your Go import lines, adding missing ones and removing unreferenced ones.";
    homepage = "https://pkg.go.dev/golang.org/x/tools/cmd/goimports";
    license = licenses.bsd3;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
