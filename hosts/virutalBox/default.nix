# this defines the function signature of our expression, pkgs is defaulted to the systems packages,
# you could also overrides that if you need a specific release / channel.
{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib }:

let
  # this creates a helper function that abstracts a bit of the boilerplate away
  # `mkVM` takes one argument, a list of `modules` to include in the image.
  mkVM = mods:
    (import <nixpkgs/nixos/lib/eval-config.nix> {
      modules = [
        # include the standard virtualbox demo install that probably includes things like KDE or whatever
        # <nixpkgs/nixos/modules/installer/virtualbox-demo.nix>

        # base virtualbox config
        (with lib; {
          imports = [
            <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix>
            <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
            # <nixpkgs/nixos/modules/profiles/demo.nix>
            <nixpkgs/nixos/modules/profiles/clone-config.nix>
          ];

          # FIXME: UUID detection is currently broken
          boot.loader.grub.fsIdentifier = "provided";

          # Add some more video drivers to give X11 a shot at working in
          # VMware and QEMU.
          services.xserver.videoDrivers = mkOverride 40 [
            "virtualbox"
            "vmware"
            "cirrus"
            "vesa"
            "modesetting"
          ];

          powerManagement.enable = false;
          system.stateVersion = mkDefault "22.05";

          users.users.demo = {
            isNormalUser = true;
            description = "Demo user account";

            # Allow sudo and mounting of shared folders.
            extraGroups = [ "wheel" "vboxsf" ];
            password = "demo";
            uid = 1000;
          };

          services.xserver = {
            displayManager = {
              autoLogin = {
                enable = true;
                user = "demo";
              };

              sddm = { enable = mkForce false; };
              gdm = { enable = true; };
            };
            desktopManager = { plasma5.enable = mkForce false; };
          };

          # not sure if this is needed
          # installer.cloneConfigExtra = ''
          # # Let demo build as a trusted user.
          # # nix.settings.trusted-users = [ "demo" ];
          # # Mount a VirtualBox shared folder.
          # # This is configurable in the VirtualBox menu at
          # # Machine / Settings / Shared Folders.
          # # fileSystems."/mnt" = {
          # #   fsType = "vboxsf";
          # #   device = "nameofdevicetomount";
          # #   options = [ "rw" ];
          # # };
          # # By default, the NixOS VirtualBox demo image includes SDDM and Plasma.
          # # If you prefer another desktop manager or display manager, you may want
          # # to disable the default.
          # # services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
          # # services.xserver.displayManager.sddm.enable = lib.mkForce false;
          # # Enable GDM/GNOME by uncommenting above two lines and two lines below.
          # # services.xserver.displayManager.gdm.enable = true;
          # # services.xserver.desktopManager.gnome.enable = true;
          # # Set your time zone.
          # # time.timeZone = "Europe/Amsterdam";
          # # List packages installed in system profile. To search, run:
          # # \$ nix search wget
          # # environment.systemPackages = with pkgs; [
          # #   wget vim
          # # ];
          # # Enable the OpenSSH daemon.
          # # services.openssh.enable = true;
          # '';
        })

        # custom configuration
        # { imports = [ ./configuration.nix ]; }
      ] ++ mods;
    }).config.system.build.virtualBoxOVA;
in
{
  # delcares the target of an example image with gnome
  # build with: nix-build . -A withGnome
  withGnome = mkVM [
    # add some custom pkgs like vim and tmux, could be our internal packages
    # ({ pkgs, ... }: { imports = [ ../../nix/nixos/desktops/gnome.nix ]; })
  ];
}
