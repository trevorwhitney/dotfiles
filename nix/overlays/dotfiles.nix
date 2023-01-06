final: prev:
let
  tmuxPlugins = prev.callPackage ../packages/tmux-plugins {
    nixpkgs = prev;
  };

  callRunCommandPkg = file:
    prev.callPackage file { inherit (prev) lib runCommand; };

  callBuildGoModulePkg = file:
    prev.callPackage file {
      inherit (prev) lib buildGoModule fetchFromGitHub;
    };
in
{
  inherit (tmuxPlugins) tw-tmux-lib;
  dotfiles =
    prev.callPackage ../packages/dotfiles { inherit (prev) stdenv pkgs lib; };

  git-template = callRunCommandPkg ../packages/git-template;
  kns-ktx = callRunCommandPkg ../packages/kns-ktx;
  oh-my-zsh-custom =
    callRunCommandPkg ../packages/oh-my-zsh-custom;

  faillint = callBuildGoModulePkg ../packages/faillint;
  gocomplete = callBuildGoModulePkg ../packages/gocomplete;
  jsonnet-language-server =
    callBuildGoModulePkg ../packages/jsonnet-language-server;
  jsonnet-lint =
    callBuildGoModulePkg ../packages/jsonnet-lint;
  mixtool = callBuildGoModulePkg ../packages/mixtool;
  protoc-gen-gogofast =
    callBuildGoModulePkg ../packages/protoc-gen-gogofast;
  protoc-gen-gogoslick =
    callBuildGoModulePkg ../packages/protoc-gen-gogoslick;
  xk6 = callBuildGoModulePkg ../packages/xk6;

  jdtls = prev.callPackage ../packages/jdtls {
    inherit (prev) stdenv fetchzip lib pkgs;
  };
  polybar-themes =
    prev.callPackage ../packages/polybar-themes {
      inherit (prev) fetchFromGitHub lib runCommand;
    };
  mosh = prev.callPackage ../packages/mosh {
    inherit (prev) pkgs;
  };
  stylua = prev.callPackage ../packages/stylua {
    inherit (prev) lib rustPlatform fetchFromGitHub;
  };
}
