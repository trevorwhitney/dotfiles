{
  description = "My dotfiles and overlays";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    {
      overlay = (final: prev: {
        dotfiles = prev.callPackage ./default.nix {
          inherit (prev) stdenv pkgs lib;
        };
        git-template = prev.callPackage ./packages/git-template/default.nix {
          inherit (prev) lib runCommand;
        };
        gocomplete = prev.callPackage ./packages/gocomplete/default.nix {
          inherit (prev) lib buildGoModule fetchFromGitHub;
        };
        jdtls = prev.callPackage ./packages/jdtls/default.nix {
          inherit (prev) stdenv fetchzip lib pkgs;
        };
        jsonnet-language-server =
          prev.callPackage ./packages/jsonnet-language-server/default.nix {
            inherit (prev) lib buildGoModule fetchFromGitHub;
          };
        jsonnet-lint = prev.callPackage ./packages/jsonnet-lint/default.nix {
          inherit (prev) lib buildGoModule fetchFromGitHub;
        };
        kns-ktx = prev.callPackage ./packages/kns-ktx/default.nix {
          inherit (prev) lib runCommand;
        };
        mosh = prev.mosh.overrideAttrs (oldAttrs: rec {
          buildInputs = oldAttrs.buildInputs ++ (with prev; [ glibcLocales ]);
          postInstall = with prev; ''
            wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB;
            wrapProgram $out/bin/mosh-server --set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive;
          '';
        });
        oh-my-zsh-custom =
          prev.callPackage ./packages/oh-my-zsh-custom/default.nix {
            inherit (prev) lib runCommand;
          };
        protoc-gen-gogofast =
          prev.callPackage ./packages/protoc-gen-gogofast/default.nix {
            inherit (prev) lib buildGoModule fetchFromGitHub;
          };
        protoc-gen-gogoslick =
          prev.callPackage ./packages/protoc-gen-gogoslick/default.nix {
            inherit (prev) lib buildGoModule fetchFromGitHub;
          };
        stylua = prev.callPackage ./packages/stylua/default.nix {
          inherit (prev) lib rustPlatform fetchFromGitHub;
        };
        xk6 = prev.callPackage ./packages/xk6/default.nix {
          inherit (prev) lib buildGoModule fetchFromGitHub;
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
          xk6 = pkgs.xk6;
        };
      }));
}
