{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goimports";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "v${version}";
    sha256 = "0h9ip7sry1y8z94jypygas4ylb403wji3vljcc5jlb54rf51x3z7";
  };

  vendorSha256 = "1zzx6vwwi2wj1mgbpck5vlj91xlrj006cvmxm5cn49rqr9dir2pd";

  subPackages = [ "cmd/goimports" ];

  meta = with lib; {
    description = "Command goimports updates your Go import lines, adding missing ones and removing unreferenced ones.";
    homepage = "https://pkg.go.dev/golang.org/x/tools/cmd/goimports";
    license = licenses.bsd3;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
