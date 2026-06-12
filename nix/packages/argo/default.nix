{ stdenv
, lib
, fetchurl
, gzip
, installShellFiles
}:
let
  version = "4.0.6";

  # Release assets are single gzipped binaries named argo-<os>-<arch>.gz.
  # Hashes come from the GitHub release asset digests.
  sources = {
    aarch64-darwin = {
      asset = "argo-darwin-arm64.gz";
      hash = "sha256-wDuA6Q1+NzBB1Zx23RPoNtLvzmT+c+naBtdLWWjgdJ4=";
    };
    x86_64-darwin = {
      asset = "argo-darwin-amd64.gz";
      hash = "sha256-NETJCfV2xnwFk707wWZM95Ylc2Fsu73TjRMmMg7Z9fY=";
    };
    aarch64-linux = {
      asset = "argo-linux-arm64.gz";
      hash = "sha256-pLbvYN32z5lhhuD23Rx0TlOU/i7aKM6itsM9dP4FClc=";
    };
    x86_64-linux = {
      asset = "argo-linux-amd64.gz";
      hash = "sha256-js3CXczhdUEgk8ybBP3RBjsefWNekL5tAWQ/yyWjVuE=";
    };
  };

  source = sources.${stdenv.hostPlatform.system} or (throw "argo: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "argo";
  inherit version;

  src = fetchurl {
    url = "https://github.com/argoproj/argo-workflows/releases/download/v${version}/${source.asset}";
    inherit (source) hash;
  };

  nativeBuildInputs = [ gzip installShellFiles ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    gunzip -c $src > $out/bin/argo
    chmod +x $out/bin/argo

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd argo \
      --bash <($out/bin/argo completion bash) \
      --zsh <($out/bin/argo completion zsh)
  '';

  meta = with lib; {
    description = "Argo Workflows CLI for Kubernetes";
    homepage = "https://github.com/argoproj/argo-workflows";
    license = licenses.asl20;
    maintainers = with maintainers; [ trevorwhitney ];
    mainProgram = "argo";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
