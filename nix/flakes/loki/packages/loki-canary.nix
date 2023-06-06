{ loki, ... }: loki.overrideAttrs
  (old: {
    pname = "loki-canary";

    buildPhase = ''
      export GOCACHE=$TMPDIR/go-cache
      make clean loki-canary
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -m755 cmd/loki-canary/loki-canary $out/bin/loki-canary
    '';
  })
