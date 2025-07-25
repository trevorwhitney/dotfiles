{ config, pkgs, lib, ... }:
let
  inherit (pkgs) git-template;
  cfg = config.programs.git;
in
{
  options = { };
  config = {
    programs.git = {
      enable = true;
      userName = "Trevor Whitney";
      userEmail = "trevorjwhitney@gmail.com";
      delta = { enable = true; };

      lfs = {
        enable = true;
        skipSmudge = true;
      };

      aliases = {
        st = "status";
        di = "diff";
        co = "checkout";
        ci = "commit";
        br = "branch";
        sta = "stash";
        llog = "log --date=local";
        flog = "log --pretty=fuller --decorate";
        lg =
          "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        lol = "log --graph --decorate --oneline";
        lola = "log --graph --decorate --oneline --all";
        blog = "log origin/master... --left-right";
        ds = "diff --staged";
        fixup = "commit --fixup";
        squash = "commit --squash";
        unstage = "reset HEAD";
        rum = "rebase";
        ctags = "!.git/hooks/ctags";
        sur = "submodule update --recursive";
        cane = "commit --amend --no-edit";
        root = "rev-parse --show-toplevel";
        wip = "commit --all -m wip";
      };

      extraConfig = {
        core = {
          editor = "nvim";
          excludesfile = "~/.config/git/ignore";
        };
        apply = { whitespace = "nowarn"; };
        color = {
          branch = "auto";
          diff = "auto";
          interactive = "auto";
          status = "auto";
          ui = "auto";
        };
        branch = { autosetupmerge = true; };
        rebase = { autosquash = true; };
        push = { default = "simple"; };
        merge = { tool = "vimdiff"; };
        diff = { tool = "vimdiff"; };
        mergetool = { keepBackup = false; };
        init = {
          templatedir = "${git-template}";
          defaultBranch = "main";
        };
      };

      ignores = [
        ".DS_Store"
        "*.iml"
        "*.classpath"
        "*.project"
        "*.eml"
        ".gradle"
        ".vagrant"
        ".envrc"
        ".direnv"
        ".idea"
        ".vscode"
        ".vim"
        "__debug_bin*"
        ".codespellrc"
        ".aider*"
        ".env"
        "MEMORY.md"
        ".claude"
        ".worktrees"
      ];
    };

    home.packages = with pkgs; [
      delta
    ];
  };
}
