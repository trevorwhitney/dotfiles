# vi: ft=nix
{ config, pkgs, lib, ... }:
let custom = pkgs.oh-my-zsh-custom;
in
{
  programs.zsh = {
    enable = true;
    autocd = false;
    enableAutosuggestions = true;
    defaultKeymap = "viins";
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
      theme = "twhitney";
      plugins = [ "ruby" "vi-mode" "mvn" "aws" "docker" "docker-compose" ];
      custom = "${custom}";
    };

    sessionVariables = {
      WORDCHARS = "*?_-.[]~=&;!#$%^(){}<>";
      HYPHEN_INSENSITIVE = "true";
      ZSH_AUTOSUGGEST_STRATEGY = [ "history" "completion" ];
    };

    initExtra = builtins.concatStringsSep "\n" (with pkgs; [
      ''
        # Fuzzy completion for history
        [ -f "${fzf}/share/fzf/completion.zsh" ] && source "${fzf}/share/fzf/completion.zsh"
        [ -f "${fzf}/share/fzf/key-bindings.zsh" ] && source "${fzf}/share/fzf/key-bindings.zsh"
      ''
      (lib.strings.fileContents ./lib/zshrc)
    ]);
  };
}
