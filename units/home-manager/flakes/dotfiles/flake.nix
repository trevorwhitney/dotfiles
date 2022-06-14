{
  description = "My dotfiles and overlays";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    {
      overlay = (final: prev:
        let
          tmuxPlugins = prev.callPackage ./packages/tmux-plugins/default.nix {
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
          dotfiles =
            prev.callPackage ./default.nix { inherit (prev) stdenv pkgs lib; };

          git-template = callRunCommandPkg ./packages/git-template/default.nix;
          kns-ktx = callRunCommandPkg ./packages/kns-ktx/default.nix;
          oh-my-zsh-custom =
            callRunCommandPkg ./packages/oh-my-zsh-custom/default.nix;

          gocomplete = callBuildGoModulePkg ./packages/gocomplete/default.nix;
          jsonnet-language-server =
            callBuildGoModulePkg ./packages/jsonnet-language-server/default.nix;
          jsonnet-lint =
            callBuildGoModulePkg ./packages/jsonnet-lint/default.nix;
          protoc-gen-gogofast =
            callBuildGoModulePkg ./packages/protoc-gen-gogofast/default.nix;
          protoc-gen-gogoslick =
            callBuildGoModulePkg ./packages/protoc-gen-gogoslick/default.nix;
          xk6 = callBuildGoModulePkg ./packages/xk6/default.nix;

          tmux-cpu = tmuxPlugins.tmux-cpu;
          tw-tmux-lib = tmuxPlugins.tw-tmux-lib;

          jdtls = prev.callPackage ./packages/jdtls/default.nix {
            inherit (prev) stdenv fetchzip lib pkgs;
          };

          mosh = prev.mosh.overrideAttrs (oldAttrs: rec {
            buildInputs = oldAttrs.buildInputs ++ (with prev; [ glibcLocales ]);
            postInstall = with prev; ''
              wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB;
              wrapProgram $out/bin/mosh-server --set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive;
            '';
          });

          stylua = prev.callPackage ./packages/stylua/default.nix {
            inherit (prev) lib rustPlatform fetchFromGitHub;
          };
        });
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in
      {
        defaultPackage = pkgs.dotfiles;
        devShell = import ./shell.nix { inherit pkgs; };
        packages = {
          dotfiles = pkgs.dotfiles;
          git-template = pkgs.git-template;
          gocomplete = pkgs.gocomplete;
          jdtls = pkgs.jdtls;
          jsonnet-language-server = pkgs.jsonnet-language-server;
          jsonnet-lint = pkgs.jsonnet-lint;
          kns-ktx = pkgs.kns-ktx;
          mosh = pkgs.mosh;
          oh-my-zsh-custom = pkgs.oh-my-zsh-custom;
          protoc-gen-gogofast = pkgs.protoc-gen-gogofast;
          protoc-gen-gogoslick = pkgs.protoc-gen-gogoslick;
          stylua = pkgs.stylua;
          xk6 = pkgs.xk6;
          tw-tmux-lib = pkgs.tw-tmux-lib;
          tmux-cpu = pkgs.tmux-cpu;
        };
      }));
}
