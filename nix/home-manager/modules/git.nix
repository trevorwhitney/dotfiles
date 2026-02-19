{ config
, pkgs
, lib
, ...
}:
let
  inherit (pkgs) git-template;
  cfg = config.programs.git;
in
{
  options = { };
  config = {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Trevor Whitney";
          email = "trevorjwhitney@gmail.com";
        };

        alias = {
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
          root = "rev-parse --show-toplevel";
          wip = "commit --all -m wip";
        };

        core = {
          editor = "nvim";
          excludesfile = "~/.config/git/ignore";
        };
        apply = {
          whitespace = "nowarn";
        };
        color = {
          branch = "auto";
          diff = "auto";
          interactive = "auto";
          status = "auto";
          ui = "auto";
        };
        branch = {
          autosetupmerge = true;
        };
        rebase = {
          autosquash = true;
        };
        push = {
          default = "simple";
        };
        merge = {
          tool = "diffview";
        };
        diff = {
          tool = "nvimdiff";
        };
        mergetool = {
          keepBackup = false;
          diffview = {
            cmd = ''nvim -n -c "set wrap" -c "DiffviewOpen -uno" "''$MERGE"'';
          };
        };
        init = {
          templatedir = "${git-template}";
          defaultBranch = "main";
        };
      };

      lfs = {
        enable = true;
        skipSmudge = true;
      };

      ignores = [
        "*.classpath"
        "*.eml"
        "*.iml"
        "*.project"
        ".DS_Store"
        ".aider*"
        ".codespellrc"
        ".direnv"
        ".env"
        ".envrc"
        ".gradle"
        ".idea"
        ".vagrant"
        ".vim"
        ".vscode"
        ".worktrees"
        ".zed"
        "MEMORY.md"
        "__debug_bin*"
        ".planning"
      ];
    };

    home.packages = with pkgs; [
      delta
    ];
  };
}
