{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gocomplete";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "posener";
    repo = "complete";
    rev = "v${version}";
    sha256 = "HlKkAknO1C3TfRtRkwdvoQTmA7uUzg4vHP0yO0ZNMjI=";
  };

  vendorHash = "sha256-2WF5Q0cOPkmdFfwE5/WAXtCuttLtsDteIbC2COf5phE=";

  subPackages = [ "gocomplete" ];

  meta = with lib; {
    description = "Everything for bash completion and Go";
    homepage = "https://github.com/posener/complete";
    license = licenses.mit;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
