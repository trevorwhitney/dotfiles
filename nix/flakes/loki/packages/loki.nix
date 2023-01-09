{ pkgs, ... }: pkgs.loki.overrideAttrs
  (old: with pkgs; {
    postConfigurePhase = ''
      substituteInPlace clients/cmd/fluentd/Makefile \
        --replace "SHELL    = /usr/bin/env bash -o pipefail" "SHELL = ${bash}/bin/bash -o pipefail"
    '';
  })
