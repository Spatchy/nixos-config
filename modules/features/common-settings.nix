{ self, inputs, ...}: {

  flake.nixosModules.common-settings = { pkgs, lib, ... }: {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Enable automatic garbage collection
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Enable networking
    networking.networkmanager.enable = true;

    # Set time zone.
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

    # Configure console keymap
    console.keyMap = "uk";

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "gb";
      variant = "";
    };

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver.enable = false;

    # Enable GPG
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable running non-nix executables
    programs.nix-ld.enable = true;

    # Enable direnv for better development with flakes
    programs.direnv.enable = true;

    # Enable portals
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
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
  };
}