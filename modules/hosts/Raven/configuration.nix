{self, inputs, ...}: {

  flake.nixosModules.RavenConfig = { pkgs, lib, ... }: {

    imports = [
      self.nixosModules.RavenHardware
      self.nixosModules.fonts
      self.nixosModules.common-settings
    ];    

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "Raven"; # Define your hostname.
    networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Enable the Cage kiosk.
    services.cage.enable = true;
    services.cage.program = "${pkgs.pegasus-frontend}/bin/pegasus-fe";
    services.cage.user = "james";

    # Enable and configure GPU drivers
    services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
    hardware.nvidia.open = true;

    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.prime.offload.enable = true;

    hardware.nvidia.prime = {
      amdgpuBusId = "PCI:0@1:0:0";
      nvidiaBusId = "PCI:0@4:0:0";
    };

    # offload everything to the dedicated GPU
    environment.sessionVariables = {
      __NV_PRIME_RENDER_OFFLOAD=1;
      __NV_PRIME_RENDER_OFFLOAD_PROVIDER="NVIDIA-G0";
      __GLX_VENDOR_LIBRARY_NAME="nvidia";
      __VK_LAYER_NV_optimus="NVIDIA_only";
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.james = {
      isNormalUser = true;
      description = "James";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [ ];
    };

    # Enable xone gamepad driver
    hardware.xone.enable = true;

    # Enable programs
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.kdeconnect.enable = true;

    environment.systemPackages = with pkgs; [
      pegasus-frontend
      heroic
      inputs.fjordlauncher.packages.${pkgs.stdenv.hostPlatform.system}.fjordlauncher
      moonlight-qt
      dolphin-emu
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05"; # Did you read the comment?

  };
}
