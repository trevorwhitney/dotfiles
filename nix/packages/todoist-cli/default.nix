{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "todoist-cli";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "Doist";
    repo = "todoist-cli";
    rev = "v${version}";
    hash = "sha256-3gI44u7BVCPt7yQOtm+5dpAm3WfcIZY4iXTwwlnZ0H4=";
  };

  npmDepsHash = "sha256-BqZ2jZcqaRSLYUoYduNmpz53AunwZwqHft6vM4WsODc=";

  # Build TypeScript sources
  npmBuildScript = "build";

  meta = with lib; {
    description = "Command-line interface for Todoist";
    homepage = "https://github.com/Doist/todoist-cli";
    license = licenses.mit;
    mainProgram = "td";
  };
}
