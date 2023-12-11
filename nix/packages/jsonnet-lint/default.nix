{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jsonnet-lint";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "go-jsonnet";
    rev = "v${version}";
    sha256 = "1rprs8l15nbrx4dw4pdg81c5l22zhj80pl4zwqgsm4113wyyvc98";
  };

  vendorHash = "sha256-wUoR67BtUgb0jChkvapq8Mc4GD7VROfJ9xXZtfQjVVs=";

  subPackages = [ "cmd/jsonnet-lint" ];

  meta = with lib; {
    description = "A Jsonnet linter written in pure Go";
    homepage = "https://github.com/google/go-jsonnet";
    license = licenses.asl20;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
