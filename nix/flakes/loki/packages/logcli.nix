{ loki, ... }: loki.overrideAttrs
  (old: {
    pname = "logcli";

    buildPhase = ''
      export GOCACHE=$TMPDIR/go-cache
      make clean logcli
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -m755 cmd/logcli/logcli $out/bin/logcli
    '';
  })
