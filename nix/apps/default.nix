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
  logcli = {
    type = "app";
    program = "${
      pkgs.logcli.overrideAttrs (old: {
        doCheck = false;
      })
    }/bin/logcli";
  };
}
