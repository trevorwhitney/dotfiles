{config, ...}: {
  age = {
    secrets = {
      "deploymentTools.sh".file = ../../secrets/deploymentTools.sh.age;
    };
    secretsDir = "${config.users.users.twhitney.home}/.agenix/secrets";
    identityPaths = [ "${config.users.users.twhitney.home}/.config/agenix/id_ed25519" ];
  };
}
