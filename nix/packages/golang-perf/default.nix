{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "golang-perf";
  commit = "b53752263861";
  version = "0.0.0-${commit}";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "perf";
    rev = "${commit}";
    sha256 = "Jow4F7vZIQk9i+OQA+iCoepQ00IyTieh53ujOpu65Mg=";
  };

  vendorHash = "sha256-2+auQXHcNYc7KfbccIcvMb1aSq7sryJ/oqgcuBRCO9w=";
  doCheck = false;
  subPackages = [ "cmd/benchstat" "cmd/benchfilter" "cmd/benchsave" ];

  meta = with lib; {
    description =
      "Go benchmark analysis tools";
    homepage = "https://github.com/golang/perf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
