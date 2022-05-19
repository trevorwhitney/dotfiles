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

  vendorSha256 = "7YocW8o4J2JZqb1uZgCQmfaQJN1lsrteDZKLyPk2/f8=";

  subPackages = [ "cmd/goimports" ];

  meta = with lib; {
    description = "Command goimports updates your Go import lines, adding missing ones and removing unreferenced ones.";
    homepage = "https://pkg.go.dev/golang.org/x/tools/cmd/goimports";
    license = licenses.bsd3;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
