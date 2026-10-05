{ self, inputs, ...}: {

  flake.nixosModules.plasma-bigscreen = { pkgs, lib, ... }: {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = “breeze”;
      };

      sessionPackages = [ pkgs.kdePackages.plasma-bigscreen ];
      autoLogin.enable = true;
      autoLogin.user = "james";
    };

    xdg.portal.configPackages = [ pkgs.kdePackages.plasma-bigscreen ];

    programs.kdeconnect.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.plasma-bigscreen
    ];
  };
}
