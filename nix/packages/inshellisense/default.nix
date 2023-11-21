{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "inshellisense";
  version = "0.0.1-rc.3";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = "${version}";
    sha256 = "g4AZ1+Jq6G5F3jq2jVSOkfR1fVITGgNTGb1YRFLzcAQ=";
  };

  npmDepsHash = "sha256-YsLfsnEUk98yH4KmQQsQn2Xg4U9fTDhTF/VwWxtxMKo=";

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = [ "--ignore-scripts" ];

  NODE_OPTIONS = "--openssl-legacy-provider";

  meta = with lib; {
    homepage = "https://github.com/microsoft/inshellisense";
    license = licenses.mit;
    maintainers = with maintainers; [ trevorwhitney ];
  };
}
