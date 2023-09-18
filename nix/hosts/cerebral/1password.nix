{ ... }:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "twhitney" ];
  };

  # allow me to use 1password ssh agent without password prompt
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.user == "twhitney" && 
          action.id == "com.1password.1Password.unlock") {
        return polkit.Result.YES;
      }
    });
  '';
}
