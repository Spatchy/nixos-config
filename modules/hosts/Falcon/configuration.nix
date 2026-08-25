{self, inputs, ...}: {

  flake.nixosModules.FalconConfig = { pkgs, lib, ... }: {

    imports = [
      self.nixosModules.FalconHardware
      self.nixosModules.fonts
      self.nixosModules.common-settings
      self.nixosModules.virtualisation
      self.nixosModules.desktop-apps
    ];    

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.kernelModules = [ "amdgpu" ];

    networking.hostName = "Falcon"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    # Enable GoXLR utils
    services.goxlr-utility.enable = true;

    # Enable AMD GPU drivers
    services.xserver.videoDrivers = [ "amdgpu" ];

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

    # Enable automatic login for the user.
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "james";

    # Enable WiVRn for VR/XR
    services.wivrn = {
      enable = true;
      openFirewall = true;

      # Run WiVRn as a systemd service on startup
      autoStart = false;

      # Request high priority from GPU driver for async reprojection
      highPriority = true;

      # Set global runtime redirect
      steam.importOXRRuntimes = true;
    };

    # Enable Sunshine for streaming to remote displays
    services.sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    # Enable xone gamepad driver
    hardware.xone.enable = true;

    # Enable programs
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.kdeconnect.enable = true;

    environment.systemPackages = with pkgs; [
      vesktop
      mangohud
      heroic
      inputs.fjordlauncher.packages.${pkgs.stdenv.hostPlatform.system}.fjordlauncher
      moonlight-qt
      bs-manager
      inputs.amethyst-mod-manager.packages.${pkgs.stdenv.hostPlatform.system}.amethyst-mod-manager
      pakku
      eden
      dolphin-emu
      inputs.freegosy.packages.${pkgs.stdenv.hostPlatform.system}.default
      zapzap
      cinny-desktop
      vscodium
      arduino-ide
      libreoffice-fresh
      hunspell
      hunspellDicts.en-gb-ise
      gimp
      tenacity
      inkscape
      krita
      pixieditor
      plezy
      feishin
      ungoogled-chromium
      librewolf
      freecad
      orca-slicer
      newsflash
      rpi-imager
      # Shell utils
      pv
      unrar
      minicom
      rkdeveloptool
      android-tools
      yt-dlp
      zip
      # OBS and plugins
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
          obs-vaapi #optional AMD hardware acceleration
          obs-vkcapture
        ];
      })
      # KDE specific packages
      kdePackages.kdenlive
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
    system.stateVersion = "25.05"; # Did you read the comment?

  };
}
