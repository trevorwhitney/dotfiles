{ config, pkgs, ... }: {
  # enable virtualbox
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  /*
    The following allow virtualbox to automatically start certain VMs on boot.

    Manually create the file /etc/vbox/autostart.cfg

    # deny by default
    default_policy = deny

    # allow autostart per user
    twhitney = {
    allow = true
    }

    Give /etc/vbox/autostart.cfg the correct permissions

    chgrp vboxusers /etc/vbox
    chmod 1775 /etc/vbox

    Choose VMs to automatically start and stop

    * The first time a user configures autostart, the command: `VBoxManage setproperty autostartdbpath /etc/vbox` needs to be run.
    * _Note_: The autostart options are stored in the /etc/vbox file, and the VM itself. If moving the vm, the options may need to be set again.
    * `VBoxManage modifyvm <uuid|vmname> --autostart-enabled <on|off>`
    * You can also: `VBoxManage modifyvm <uuid|vmname> --autostop-type <disabled|savestate|poweroff|acpishutdown>`
    * `sudo service vboxautostart-service restart`
  */

  environment.etc = {
    "default/virtualbox".text = ''
      VBOXAUTOSTART_DB=/etc/vbox
      VBOXAUTOSTART_CONFIG=/etc/vbox/autostart.cfg
    '';
  };

  systemd.services."vbox@" = {
    description = "Virtual Box Guest %I";
    after = [ "network.target" "vboxdrv.service" ];
    before = [ "runlevel2.target" "shutdown.target" ];
    # List of VMs to start
    wantedBy = [ "vbox@monterey.service" ];
    serviceConfig = {
      User = "twhitney";
      Group = "vboxusers";
      Type = "forking";
      Restart = "no";
      TimeoutSec = "5min";
      IgnoreSIGPIPE = "no";
      KillMode = "process";
      GuessMainPID = "no";
      RemainAfterExit = "yes";
      ExecStart = "/run/current-system/sw/bin/VBoxManage startvm %I --type headless";
      ExecStop = "/run/current-system/sw/bin/VBoxManage controlvm %I acpipowerbutton";
    };
  };
}
