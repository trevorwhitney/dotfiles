{
  description = "Stem NixOS System Config";

  inputs = {
    #TODO: building azure-cli broken after this SHA due to inability to find
    #azure-data-tables==12.4.0
    nixpkgs.url = "github:nixpkgs/nixos-unstable?rev=6c8644fc37b6e141cbfa6c7dc8d98846c4ff0c2e";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    neovim.inputs.flake-utils.follows = "flake-utils";

    #TODO: replace with https://github.com/ryantm/agenix
    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=817364ca6919c2dd1462f1a316998c735d30d625";

    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";

    # For running OpenGL apps outside of NixOS
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.inputs.flake-utils.follows = "flake-utils";

    # Hardware specific configs
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Firefox nightly
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";

    # For creating nixos images for various platforms
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For deploying remote systems
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    # Nix User Repository
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    { self
    , deploy-rs
    , flake-utils
    , home-manager
    , neovim
    , nixgl
    , nixos-generators
    , nixos-hardware
    , nixpkgs
    , nixpkgs-mozilla
    , nur
    , secrets
    , ...
    }:
    let
      inherit (nixpkgs) lib;
      overlays = [
        (import "${self}/nix/overlays/dotfiles.nix")
        (import "${self}/nix/overlays/i3-gnome-flashback.nix")

        deploy-rs.overlay
        neovim.overlay
        nixgl.overlay
        nixpkgs-mozilla.overlays.firefox
        secrets.overlay
      ];

      pkgs = import nixpkgs {
        inherit overlays;
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          #TODO: what needs python 2.7?
          #Is it Davinci-resolve?
          permittedInsecurePackages = [
            "python-2.7.18.6"
          ];
        };
      };

      nix = import ./nix {
        inherit self secrets pkgs lib flake-utils home-manager nur nixos-hardware;
        modulesPath = "${nixpkgs}/nixos/modules";
      };
    in
    {
      inherit (nix) nixosConfigurations;
      # deploy .#monterey
      deploy.nodes.monterey = {
        hostname = "localhost";
        sshUser = "twhitney";
        user = "root";
        sshOpts = [ "-p" "2222" ]; # uses NAT interface on VM
        profiles = {
          system = {
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."monterey";
          };
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
      homeConfigurations = {
        "twhitney@cerebral" = nix.homeConfigurations.x86_64-linux."twhitney@cerebral";
        "twhitney@penguin" = nix.homeConfigurations.x86_64-linux."twhitney@penguin";
      };
    } // (flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      devShells = {
        default = import ./shell.nix { inherit pkgs; };
      };
      apps = {
        install-monterey-vm = {
          type = "app";
          program = with pkgs; "${
                (writeShellScriptBin "install.sh" ''
                  VBoxManage import ./result/monterey.ova
                  VBoxManage modifyvm monterey --natpf1 "ssh,tcp,,2222,,22"
                  VBoxManage modifyvm monterey --nic2 bridged --nictype2 82540EM --bridgeadapter2 enp9s0
                  VBoxManage modifyvm monterey --usbxhci on
                  VBoxManage startvm monterey --type separate
                '')
              }/bin/install.sh";
        };
        start-monterey-vm = {
          type = "app";
          program = with pkgs; "${
                (writeShellScriptBin "install.sh" ''
                  VBoxManage startvm monterey --type separate
                '')
              }/bin/install.sh";
        };
        # for automation, may want to build something around this
        # VBoxManage guestproperty get monterey "/VirtualBox/GuestInfo/OS/LoggedInUsers"
        attach-monterey-drives = {
          type = "app";
          program = with pkgs; "${
                (writeShellScriptBin "attach.sh" ''
                  VBoxManage controlvm monterey usbattach sysfs:/sys/devices/pci0000:00/0000:00:01.3/0000:02:00.0/usb2/2-2//device:/dev/vboxusb/002/003
                  VBoxManage controlvm monterey usbattach sysfs:/sys/devices/pci0000:00/0000:00:01.3/0000:02:00.0/usb2/2-1//device:/dev/vboxusb/002/002
                '')
              }/bin/attach.sh";
        };
      };
      packages = {
        inherit (pkgs) i3-gnome-flashback;
        #TODO: this is an experiment
        monterey-libvirt = nixos-generators.nixosGenerate {
          inherit system;
          format = "qcow";
          modules = [
            ./nix/modules/virtualbox.nix
            ./nix/hosts/monterey/root.nix
            ./nix/hosts/monterey/twhitney.nix
            # TODO: monterey needs to sync /var/lib
            {
              nixpkgs = {
                inherit pkgs;
                hostPlatform = "x86_64-linux";
              };
              services.xserver = {
                desktopManager.xterm.enable = true;
              };
            }
          ];
        };
        monterey-vm = nixos-generators.nixosGenerate {
          inherit system;
          format = "virtualbox";
          modules = [
            ./nix/modules/virtualbox.nix
            ./nix/hosts/monterey/root.nix
            ./nix/hosts/monterey/twhitney.nix
            {
              nixpkgs = {
                inherit pkgs;
                hostPlatform = "x86_64-linux";
              };
              services.xserver = {
                desktopManager.xterm.enable = true;
              };
              virtualbox = {
                baseImageSize = 50 * 1024;
                memorySize = 2048;
                vmDerivationName = "monterey";
                vmName = "monterey";
                vmFileName = "monterey.ova";
                params = {
                  audio = "alsa";
                  usb = "on";
                };
              };
            }
          ];
        };
      };
    }));
}
