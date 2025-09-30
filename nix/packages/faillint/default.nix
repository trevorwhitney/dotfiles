{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "faillint";
  version = "v1.15.0";

  src = fetchFromGitHub {
    owner = "fatih";
    repo = "faillint";
    rev = "${version}";
    sha256 = "sha256-fUtPw0Mn1x+P+4l2iSoAbPRxvB/4kyzVcX4wK9VpjZs=";
  };

  ldflags =
    let
      prefix = "main";
    in
    [
      "-s"
      "-w"
      "-X ${prefix}.Version=${version}"
    ];


  vendorHash = "sha256-F+geyscJcGpKfLPEVT42RO5G/2QMx5tK43URT/9y5Pk=";
  doCheck = false;

  meta = with lib; {
    description =
      "Simple Go linter than fails when specific import paths are present";
    homepage = "https://github.com/fatih/faillint";
    license = licenses.bsd3;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
