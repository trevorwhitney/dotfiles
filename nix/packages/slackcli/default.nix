{ lib, buildGoModule, go, src, version }:

(buildGoModule.override { inherit go; }) {
  pname = "slackcli";
  inherit src version;

  vendorHash = "sha256-olJYlWOn+8z2Nvja0bmD9/46icQ5zK3aLPOaREK8RZM=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Read-only CLI tool for querying the Slack API";
    homepage = "https://github.com/grafana/slackcli";
    license = licenses.asl20;
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
