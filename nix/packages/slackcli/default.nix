{ lib, buildGoModule, go, src, version }:

(buildGoModule.override { inherit go; }) {
  pname = "slackcli";
  inherit src version;

  vendorHash = "sha256-h6FN2NO8n7vTthvIIj7wQq5V4YOIjRv2DhEPb4IAifM=";

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
