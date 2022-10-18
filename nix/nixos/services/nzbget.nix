{ pkgs, lib, config, ... }:
with lib;

let
  cfg = config.services.nzbget;
  stateDir = "/var/lib/nzbget";
  pkg = cfg.package;
  inherit (cfg) configFile;
  configOpts = concatStringsSep " " (mapAttrsToList (name: value: "-o ${name}=${escapeShellArg (toStr value)}") cfg.settings);
  toStr = v:
    if v == true then "yes"
    else if v == false then "no"
    else if isInt v then toString v
    else v;
in
{
  options = {
    services.nzbget = {
      package = mkOption {
        type = types.package;
        default = pkgs.nzbget;
      };

      configFile = mkOption {
        type = types.path;
        default = "${cfg.package}/share/nzbget/nzbget.conf";
        description = "nzbget config file to use";
      };
    };
  };

  config = {
    services.nzbget.enable = true; 

    #TODO: change service and add wireguard service
    systemd.services.nzbget = {
      description = "NZBGet Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        unrar
        p7zip
      ];

      preStart = ''
        if [ ! -f ${configFile} ]; then
          ${pkgs.coreutils}/bin/install -m 0700 ${configFile} ${stateDir}/nzbget.conf
        fi
      '';

      serviceConfig = {
        StateDirectory = "nzbget";
        StateDirectoryMode = "0750";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0002";
        Restart = "on-failure";
        ExecStart = "${pkg}/bin/nzbget --server --configfile ${stateDir}/nzbget.conf ${configOpts}";
        ExecStop = "${pkg}/bin/nzbget --quit";
      };
    };
  };
}
