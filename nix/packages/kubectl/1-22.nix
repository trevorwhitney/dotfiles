{ pkgs, system }:
let
  pinnedPkgs = import
    (builtins.fetchGit {
      # Descriptive name to make the store path easier to identify
      name = "pkg-revision-with-kubernetes-1.22.6";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "6d02a514db95d3179f001a5a204595f17b89cb32";
    })
    { inherit system; };

  kubernetes-1-22-15 = pinnedPkgs.kubernetes.overrideAttrs
    (old: rec {
      version = "1.22.15";
      src = pkgs.fetchFromGitHub
        {
          owner = "kubernetes";
          repo = "kubernetes";
          rev = "v${version}";
          sha256 = "yQjAL1NWSSYJkTanNjkykgI1uaVULYejx1EGj3aMkBU=";
        };
    });
in
(pinnedPkgs.kubectl.override {
  kubernetes = kubernetes-1-22-15;
}).overrideAttrs (old: {
  installPhase = ''
    install -D ${kubernetes-1-22-15}/bin/kubectl -t $out/bin
    installManPage "${kubernetes-1-22-15.man}/share/man/man1"/kubectl*
    installShellCompletion --cmd kubectl \
      --bash <($out/bin/kubectl completion bash) \
      --zsh <($out/bin/kubectl completion zsh)
  '';
})
