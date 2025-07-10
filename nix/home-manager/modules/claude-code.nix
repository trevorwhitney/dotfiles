{pkgs, ...}: 
let
  claudeSettings = {
    permissions = {
      allow = [
        "Bash(awk:*)"
        "Bash(chmod:*)"
        "Bash(find:*)"
        "Bash(git -C * branch -a)"
        "Bash(git -C * branch status)"
        "Bash(git -C * log * status)"
        "Bash(git -C /Users/twhitney/workspace/enterprise-logs status)"
        "Bash(git checkout:*)"
        "Bash(git cherry-pick:*)"
        "Bash(git fetch:*)"
        "Bash(git rev-parse:*)"
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
      ];
      deny = [];
    };
  };
  
  prettyJson = pkgs.runCommand "claude-settings.json" {} ''
    echo '${builtins.toJSON claudeSettings}' | ${pkgs.jq}/bin/jq . > $out
  '';
in
{
  home.file.".claude/settings.json".source = prettyJson;
}
