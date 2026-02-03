{ pkgs, loki, ... }:
{
  loki = {
    type = "app";
    program = "${
      pkgs.loki.overrideAttrs (old: {
        doCheck = false;
      })
    }/bin/loki";
  };
  promtail = {
    type = "app";
    program = "${
      pkgs.promtail.overrideAttrs (old: {
        doCheck = false;
      })
    }/bin/promtail";
  };
  logcli = {
    type = "app";
    program = "${
      pkgs.logcli.overrideAttrs (old: {
        doCheck = false;
      })
    }/bin/logcli";
  };
}
