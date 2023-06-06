{ pkgs, ... }: pkgs.loki.overrideAttrs
  (old: with pkgs; {
    postConfigurePhase = ''
      substituteInPlace clients/cmd/fluentd/Makefile \
        --replace "SHELL    = /usr/bin/env bash -o pipefail" "SHELL = ${bash}/bin/bash -o pipefail"
    '';

    buildPhase = ''
      export GOCACHE=$TMPDIR/go-cache
      # make clean loki logcli loki-canary promtail
      make clean loki
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -m755 cmd/loki/loki $out/bin/loki
    '';
  })
