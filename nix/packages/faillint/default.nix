{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "faillint";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "fatih";
    repo = "faillint";
    rev = "v${version}";
    sha256 = "0viqq29w8jvqpirldx3n0r1j17kmgwqy4z0grj0j77yq13p60jmr";
  };

  vendorSha256 = "s6TG6kp64LYGPNynoBNbJvbDmT+9XgaWZewTTsi/NXs=";
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
