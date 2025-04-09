{ ... }: {
  config = {
    programs = {
      jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "Trevort Whitney";
            email = "trevorjwhitney@gmail.com";
          };
          singning = {
            behavior = "own";
            backend = "ssh";
            key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObaPLIJ0t6iar5DTKRmKCQmFzG/P0gulLkL5hUZzslf";
          };
        };
      };
      zsh = {
        shellAliases = {
          j = "jj ";
          lazyj = "lazyjj ";
        };
      };
    };
  };
}
