{ config, pkgs, lib, ... }: { 
  programs.git {
    enable = true;
    userName = "Trevor Whitney";
    userEmail = "trevorjwhitney@gmail.com";
    aliases = {
      st = "status";
      di = "diff";
      co = "checkout";
      ci = "commit";
      br = "branch";
      sta = "stash";
      llog = "log --date=local";
      flog = "log --pretty=fuller --decorate";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
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
    };
    delta = {
      enable = true;
    };
    singing = {
      signByDefault = true;
    };
    iniContent = ''
      [core]
        editor = vim
      [apply]
        whitespace = nowarn
      [color]
        branch = auto
        diff = auto
        interactive = auto
        status = auto
        ui = auto
      [branch]
        autosetupmerge = true
      [rebase]
        autosquash = true
      [push]
        default = simple
      [merge]
        tool = vimdiff
      [diff]
        tool = vimdiff
      [mergetool]
        keepBackup = false
      [init]
        templatedir = ~/.git_template
        defaultBranch = main
      [filter "lfs"]
        process = git-lfs filter-process
        required = true
        clean = git-lfs clean -- %f
        smudge = git-lfs smudge -- %f
        '';
        ignores = ''
          .DS_Store
          *.iml
          *.classpath
          *.project
          *.eml
          .gradle
          .vagrant
          .envrc
          .idea
          .vscode
          .vim
          shell.nix
          '';

  };
}
