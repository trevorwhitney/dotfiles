{ config, pkgs, lib, ... }:

let
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
      sha256 = "0dp4dcpixgj6pkynp1zvn0azh6v4mj0awx8m58rv4kl2c9p3i2mv";
    };
  };
  tmux-cpu = mkTmuxPlugin {
    pluginName = "cpu";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-cpu";
      rev = "master";
      sha256 = "1vnkkhyln4m69nrj6jzzfcs0327z99jxz01r5890n9xyqv3dky5z";
    };
  };
in
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "C-q";
    terminal = "screen-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    baseIndex = 1;
    clock24 = true;
    historyLimit = 5000;
    escapeTime = 10;
    plugins = with pkgs; [
      tw-tmux-lib
      tmuxPlugins.resurrect
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
        '';
      }
      tmuxPlugins.sessionist
      {
        plugin = tmux-cpu;
        extraConfig = "set -g @cpu_temp_unit 'F'";
      }
    ];
  };
}
