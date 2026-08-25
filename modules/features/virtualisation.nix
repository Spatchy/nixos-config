{ self, inputs, ...}: {

  flake.nixosModules.virtualisation = { pkgs, lib, ... }: {
    # Enable virtualisation
    programs.virt-manager.enable = true;
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    virtualisation.docker = {
      # Disable the system wide Docker daemon
      enable = false;

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}