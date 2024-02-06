{ nixpkgs ? import <nixpkgs> { } }:
let
  inherit (nixpkgs) stdenv lib pkgs;
  rtpPath = "share/tmux-plugins";
  addRtp = path: rtpFilePath: attrs: derivation:
    derivation // {
      rtp = "${derivation}/${path}/${rtpFilePath}";
    } // {
      overrideAttrs = f: mkTmuxPlugin (attrs // f attrs);
    };
  mkTmuxPlugin =
    a@{ pluginName
    , rtpFilePath ? (builtins.replaceStrings [ "-" ] [ "_" ] pluginName) + ".tmux"
    , namePrefix ? "tmuxplugin-"
    , src
    , unpackPhase ? ""
    , configurePhase ? ":"
    , buildPhase ? ":"
    , addonInfo ? null
    , preInstall ? ""
    , postInstall ? ""
    , path ? lib.getName pluginName
    , ...
    }:
    addRtp "${rtpPath}/${path}" rtpFilePath a (with nixpkgs;
    stdenv.mkDerivation (a // {
      pname = namePrefix + pluginName;
      name = namePrefix + pluginName;

      inherit pluginName unpackPhase configurePhase buildPhase addonInfo
        preInstall postInstall;

      installPhase = ''
        runHook preInstall
        target=$out/${rtpPath}/${path}
        mkdir -p $out/${rtpPath}
        cp -r . $target
        if [ -n "$addonInfo" ]; then
          echo "$addonInfo" > $target/addon-info.json
        fi
        runHook postInstall
      '';
    }));
in
{
  tw-tmux-lib = mkTmuxPlugin {
    pluginName = "tw-tmux-lib";
    src = pkgs.fetchFromGitHub {
      owner = "trevorwhitney";
      repo = "tw-tmux-lib";
      rev = "main";
      sha256 = "04331im5ppnkrs7h3y5bw4l7g145lxg5vdw7ba8nd77rjf6g38h6";

    };
  };
}
