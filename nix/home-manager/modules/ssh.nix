{ ... }: {
  programs.ssh = {
    enable = true;
    # use the 1password ssh agent
    extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
    '';
  };
}
