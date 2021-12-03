{ config, pkgs, lib, ... }:

let
  rtpPath = "share/tmux-plugins";
  addRtp = path: rtpFilePath: attrs: derivation:
    derivation // {
      rtp = "${derivation}/${path}/${rtpFilePath}";
    } // {
      overrideAttrs = f: mkTmuxPlugin (attrs // f attrs);
    };
  mkTmuxPlugin = a@{ pluginName, rtpFilePath ?
      (builtins.replaceStrings [ "-" ] [ "_" ] pluginName) + ".tmux"
    , namePrefix ? "tmuxplugin-", src, unpackPhase ? "", configurePhase ? ":"
    , buildPhase ? ":", addonInfo ? null, preInstall ? "", postInstall ? ""
    , path ? lib.getName pluginName, ... }:
    addRtp "${rtpPath}/${path}" rtpFilePath a (with (import <nixpkgs> { });
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
  tw-tmux-lib = mkTmuxPlugin {
    pluginName = "tw-tmux-lib";
    src = pkgs.fetchFromGitHub {
      owner = "trevorwhitney";
      repo = "tw-tmux-lib";
      rev = "main";
      sha256 = "13xf5z2ir4pmabnagafx1qj1hlvh3s4gs9d0djl5ng01015ww1gf";
    };
  };
  tmux-cpu = mkTmuxPlugin {
    pluginName = "cpu";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-cpu";
      rev = "master";
      sha256 = "00knxwys8aknjram44mhvswg7bpcsvz7kzwa3fv4j9p2bk0v38rl";
    };
  };
in {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shortcut = "q";
    terminal = "screen-256color";
    baseIndex = 1;
    clock24 = true;
    historyLimit = 5000;
    escapeTime = 10;
    plugins = with pkgs; [
      tw-tmux-lib
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
      tmuxPlugins.sessionist
      {
        plugin = tmux-cpu;
        extraConfig = "set -g @cpu_temp_unit 'F'";
      }
    ];
  };
}
