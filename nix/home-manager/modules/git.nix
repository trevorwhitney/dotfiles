{ config, pkgs, lib, ... }:
let
  inherit (pkgs) git-template;
  cfg = config.programs.git;
in
{
  options = {
    programs.git = {
      gpgPath = lib.mkOption {
        type = lib.types.str;
        default = "/usr/bin/gpg";
        description = "path the the gpg executable";
      };
    };
  };
  config = {
    programs.git = {
      enable = true;
      userName = "Trevor Whitney";
      userEmail = "trevorjwhitney@gmail.com";
      delta = { enable = true; };

      # signing = {
      #   # inherit (cfg) gpgPath;
      #   key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObaPLIJ0t6iar5DTKRmKCQmFzG/P0gulLkL5hUZzslf";
      #   signByDefault = true;
      #   format = "ssh";
      # };

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

        credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";

        # use 1password ssh key for signing commits
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObaPLIJ0t6iar5DTKRmKCQmFzG/P0gulLkL5hUZzslf";
        gpg.format = "ssh";
        gpg.ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
        commit.gpgsign = true;
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
      ];
    };
  };
}
