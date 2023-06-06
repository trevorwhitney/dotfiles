{ pkgs, loki, ... }: loki.overrideAttrs
  (old: with pkgs; {
    pname = "promtail";

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = old.buildInputs ++ lib.optionals stdenv.isLinux [ systemd.dev ];

    buildPhase = ''
      export GOCACHE=$TMPDIR/go-cache
      ${lib.optionalString stdenv.isLinux ''
        export PROMTAIL_JOURNAL_ENABLED=true
      ''}
      make clean promtail
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -m755 clients/cmd/promtail/promtail $out/bin/promtail
    '';

    preFixup = lib.optionalString stdenv.isLinux ''
      wrapProgram $out/bin/promtail \
        --prefix LD_LIBRARY_PATH : "${lib.getLib systemd}/lib"
    '';
  })
