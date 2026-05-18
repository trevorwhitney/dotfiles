{ lib, buildGoModule, src, version }:

buildGoModule {
  pname = "slackcli";
  inherit src version;

  vendorHash = lib.fakeHash;

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
