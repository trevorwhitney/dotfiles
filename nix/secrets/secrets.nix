let
  # in 1password, can't be used until https://github.com/ryantm/agenix/issues/182 is resolved
  twhitney = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObaPLIJ0t6iar5DTKRmKCQmFzG/P0gulLkL5hUZzslf";

  # stored at ~/.config/agenix
  agenix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQeR4ucBEgCTMTJDuIg5M0cs1Cjw1Tl17LQtmzkpMXl trevorjwhitney@gmail.com";
in
{
  "openAiKey.age".publicKeys = [
    twhitney
    agenix
  ];
  "anthropicApiKey.age".publicKeys = [
    twhitney
    agenix
  ];
  "openRouterApiKey.age".publicKeys = [
    twhitney
    agenix
  ];
  "ollamaCredentials.age".publicKeys = [
    twhitney
    agenix
  ];
  "deploymentTools.sh.age".publicKeys = [
    twhitney
    agenix
  ];
  "git.age".publicKeys = [
    twhitney
    agenix
  ];
  "ghToken.age".publicKeys = [
    twhitney
    agenix
  ];
  "grafana.age".publicKeys = [
    twhitney
    agenix
  ];
}
