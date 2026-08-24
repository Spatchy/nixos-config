{self, inputs, ...}: {

  flake.nixosModules.FalconConfig = { pkgs, lib, ... }: {

    imports = [
      self.nixosModules.FalconHardware
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Enable automatic garbage collection
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };


    # Enable automatic system upgrades
    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
      "--print-build-logs"
      ];
      dates = "daily";
      randomizedDelaySec = "45min";
    };

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.kernelModules = [ "amdgpu" ];

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "Falcon"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Enable nftables firewall
    networking.nftables.enable = false; # Enable this if using Waydroid to make it work

    # Set your time zone.
    time.timeZone = "Europe/London";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver.enable = false;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "gb";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "uk";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable GPG
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

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

    # Enable running non-nix executables
    programs.nix-ld.enable = true;

    # Enable direnv for better development with flakes
    programs.direnv.enable = true;

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

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

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

    # Enable portals
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };

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
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      thunderbird
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
      obsidian
      nextcloud-client
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
      mpv
      plezy
      feishin
      yt-dlp
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

    fonts.packages = with pkgs; [
      lexend
      carlito
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
