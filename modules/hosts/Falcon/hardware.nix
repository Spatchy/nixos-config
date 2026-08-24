{self, inputs, ...}: {

  flake.nixosModules.FalconHardware = { config, lib, pkgs, modulesPath, ... }: {

    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usbhid" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/77f60f2a-a85c-46c1-81c2-c21b9f78269f";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/760E-C403";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    fileSystems."/mnt/store" = {
      device = "/dev/disk/by-uuid/d8fb7995-fa03-4422-8e14-9cfe36d16b19";
      fsType = "btrfs";
    };

    swapDevices = [
      {
        device = "/dev/disk/by-uuid/1a2b291c-8b58-4b7a-aa8e-cec9925a533f";
      }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
