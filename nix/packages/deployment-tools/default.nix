{ stdenv }: stdenv.mkDerivation {
  name = "deployment-tools";
  pname = "deployment-tools";

  src = builtins.fetchGit {
    # use ssh for private repo
    url = "ssh://git@github.com/grafana/deployment_tools";
    rev = "f6a4c18b00f86256f4b00780caf02b49ee2044c3";
  };

  configurePhase = "patchShebangs scripts";

  installPhase = ''
    mkdir -p $out/bin
    install -m755 scripts/cortex/rt.sh $out/bin/rt
    install -m755 scripts/flux/ignore.sh $out/bin/flux-ignore
    install -m755 scripts/vault/vault-token $out/bin/vault-token
    install -m755 scripts/tanka/tk $out/bin/tk
  '';
}
