{ stdenv, pkgs, lib }:
stdenv.mkDerivation rec {
  name = "dotfiles";
  pname = "dotfiles";

  src = ./src;

  buildInputs = with pkgs; [
    bash
    git-template
    gocomplete
    jdtls
    jsonnet
    jsonnet-language-server
    jsonnet-lint
    kns-ktx
    mosh
    oh-my-zsh-custom
    polybar-themes
    protoc-gen-gogofast
    protoc-gen-gogoslick
    rsync
    xk6

    # python with extra packages needed for scripts
    (
      let
        extra-python-packages = python-packages:
          with python-packages; [
            click
            dbus-python
            i3ipc
            pydbus
            pygobject3
            speedtest-cli
          ];
        python-with-packages = python38.withPackages extra-python-packages;
      in
      python-with-packages
    )
  ];

  buildPhase = ''
    patchShebangs config/polybar/scripts
    patchShebangs config/polybar/launch.sh
    patchShebangs config/polybar/diodon.sh
  '';

  # rsync -av --no-group $src/ $out
  installPhase = with pkgs; ''
    mkdir -p $out
    mkdir -p $out/bin
    cp -r ${git-template} $out/git-template
    cp -r ${jdtls} $out/jdtls
    cp -r ${oh-my-zsh-custom} $out/oh-my-zsh-custom

    cp ${gocomplete}/bin/gocomplete $out/bin
    cp ${jsonnet}/bin/jsonnet $out/bin
    cp ${jsonnet-language-server}/bin/jsonnet-language-server $out/bin
    cp ${jsonnet-lint}/bin/jsonnet-lint $out/bin
    cp ${kns-ktx}/bin/kns $out/bin
    cp ${kns-ktx}/bin/ktx $out/bin
    cp ${mosh}/bin/mosh $out/bin
    cp ${protoc-gen-gogofast}/bin/protoc-gen-gogofast $out/bin
    cp ${protoc-gen-gogoslick}/bin/protoc-gen-gogoslick $out/bin
    cp ${rsync}/bin/rsync $out/bin
    cp ${xk6}/bin/xk6 $out/bin

    rsync -av --no-group ${polybar-themes}/fonts $out/polybar-fonts
    rsync -av --no-group $src/ $out
  '';

  meta = with lib; {
    description = "My dotfiles and nix overlays";
    homepage = "https://github.com/trevorwhitney/dotfiles";
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
