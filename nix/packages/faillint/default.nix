{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "faillint";
  version = "v1.14.0";

  src = fetchFromGitHub {
    owner = "fatih";
    repo = "faillint";
    rev = "${version}";
    sha256 = "NV+wbu547mtTa6dTGv7poBwWXOmu5YjqbauzolCg5qs=";
  };

  vendorHash = "sha256-vWt4HneDA7YwXYnn8TbfWCKzSv7RcgXxn/HAh6a+htQ=";
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
