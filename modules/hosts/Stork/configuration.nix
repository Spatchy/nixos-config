{self, inputs, ...}: {

  flake.nixosModules.StorkConfig = { pkgs, lib, ... }: {

    imports = [
      self.nixosModules.StorkHardware
      self.nixosModules.fonts
      self.nixosModules.common-settings
      self.nixosModules.virtualisation
      self.nixosModules.desktop-apps
    ];    

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "Stork"; # Define your hostname.
    networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Enable Tailscale
    services.tailscale.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Disable using fingerprint to login to the system (causes issues with DMs freezing & KDE Wallet)
    security.pam.services.login.fprintAuth = false;

    # Enable ZSH globally to enable nixpkgs vendor completions
    programs.zsh.enable = true;
    environment.pathsToLink = [ "/share/zsh" ];

    # Set the default shell for all users
    users.defaultUserShell = pkgs.zsh;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.james = {
      isNormalUser = true;
      description = "James";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "adbusers" "dialout"];
      packages = with pkgs; [ ];
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    # Enable xone gamepad driver
    hardware.xone.enable = true;

    programs.kdeconnect.enable = true;

    environment.systemPackages = with pkgs; [
      vesktop
      moonlight-qt
      zapzap
      vscodium
      inkscape
      feishin
      librewolf
      orca-slicer
      rpi-imager
      # Shell utils
      pv
      unrar
      minicom
      android-tools
      yt-dlp
      zip
      # KDE specific packages
      kdePackages.partitionmanager
      # Libs
      icu
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
