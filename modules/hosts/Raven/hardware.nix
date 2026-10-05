{self, inputs, ...}: {

  flake.nixosModules.RavenHardware = { config, lib, pkgs, modulesPath, ... }: {
    
    imports =
      [ (modulesPath + "/installer/scan/not-detected.nix")
      ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/fe450cf9-721a-4482-9bb1-75c82d2438f4";
        fsType = "btrfs";
      };

    fileSystems."/home" =
      { device = "/dev/disk/by-uuid/fe450cf9-721a-4482-9bb1-75c82d2438f4";
        fsType = "btrfs";
        options = [ "subvol=home" ];
      };

    fileSystems."/nix" =
      { device = "/dev/disk/by-uuid/fe450cf9-721a-4482-9bb1-75c82d2438f4";
        fsType = "btrfs";
        options = [ "subvol=nix" ];
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/8C61-2401";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
      };

    swapDevices =
      [ { device = "/dev/disk/by-uuid/a2f8a287-c528-459d-9576-0cb96da06fce"; }
      ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
