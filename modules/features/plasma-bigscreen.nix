{ self, inputs, ...}: {

  flake.nixosModules.plasma-bigscreen = { pkgs, lib, ... }: {
    services.displayManager = {
      sddm = {
        enable = true;
      };

      sessionPackages = [ pkgs.kdePackages.plasma-bigscreen ];
      autoLogin.enable = true;
      autoLogin.user = "james";
    };

    programs.kdeconnect.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.plasma-bigscreen
    ];
  };
}
