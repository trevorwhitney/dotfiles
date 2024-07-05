{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mixtool";
  version = "0.1.0-pre";

  src = fetchFromGitHub {
    owner = "monitoring-mixins";
    repo = "mixtool";
    rev = "bca30663e83cc9574fa9e841e2990bd0f6963d01";
    sha256 = "61VxHftU2KhpQkQsEKmB9yrdfDbFibohQTfa3x3HMgk=";
  };

  ldflags = [
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-H4gxVTFFH20pkwO1DYt/yIJad0HxPaUeCrr4j0s5I5I=";

  doCheck = false;

  meta = with lib; {
    description =
      "The mixtool is a helper for easily working with jsonnet mixins";
    homepage = "https://github.com/monitoring-mixins/mixtool";
    license = licenses.asl20;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
