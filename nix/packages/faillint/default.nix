{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "faillint";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "fatih";
    repo = "faillint";
    rev = "v${version}";
    sha256 = "ZSTeNp8r+Ab315N1eVDbZmEkpQUxmmVovvtqBBskuI4=";
  };

  vendorHash = "sha256-5OR6Ylkx8AnDdtweY1B9OEcIIGWsY8IwTHbR/LGnqFI=";
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
