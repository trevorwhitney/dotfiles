{ config, pkgs, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/workspace/dotfiles/dotfiles";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;

  claudeSettings = {
    permissions = {
      allow = [
        "Bash(awk:*)"
        "Bash(chmod:*)"
        "Bash(find:*)"
        "Bash(git branch:*)"
        "Bash(git checkout:*)"
        "Bash(git cherry-pick:*)"
        "Bash(git fetch:*)"
        "Bash(git log:*)"
        "Bash(git rev-parse:*)"
        "Bash(git status:*)"
        "Bash(go build:*)"
        "Bash(go run:*)"
        "Bash(go test:*)"
        "Bash(go vet:*)"
        "Bash(gofmt:*)"
        "Bash(grep:*)"
        "Bash(ls:*)"
        "Bash(make format)"
        "Bash(make lint:*)"
        "Bash(make test:*)"
        "Bash(make:*)"
        "Bash(mkdir:*)"
        "Bash(rg:*)"
        "Bash(sed:*)"
        "WebFetch(*)"
      ];
      deny = [];
    };
    auto_edit = true;
  };

  prettyJson = pkgs.runCommand "claude-settings.json" {} ''
    echo '${builtins.toJSON claudeSettings}' | ${pkgs.jq}/bin/jq . > $out
  '';

  skillNames = [
    "debug-ci-failure"
    "explain-correctness-failure"
    "fix-correctness-bug"
    "git-worktree"
    "goldfish-analyze"
    "grafana-assistant"
    "security-review"
    "tdd-workflow"
    "test-correctness-hypothesis"
  ];

  skillSymlinks = builtins.listToAttrs (map (name: {
    name = ".claude/skills/${name}";
    value = { source = mkSymlink "${dotfilesPath}/claude/skills/${name}"; };
  }) skillNames);
in
{
  home.file = {
    ".claude/settings.local.json".source = prettyJson;
  } // skillSymlinks;
}
