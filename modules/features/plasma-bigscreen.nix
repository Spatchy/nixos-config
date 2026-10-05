{ self, inputs, ...}: {

  flake.nixosModules.plasma-bigscreen = { pkgs, lib, ... }: {
    services.desktopManager.plasma6.enable = true;

    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };

      sessionPackages = [ pkgs.kdePackages.plasma-bigscreen ];
      defaultSession = "plasma-bigscreen-wayland";
      autoLogin.enable = true;
      autoLogin.user = "james";
    };

    xdg.portal.enable = true;
    xdg.portal.configPackages = [ pkgs.kdePackages.plasma-bigscreen ];

    programs.kdeconnect.enable = true;

    nixpkgs.overlays = [
      (final: prev: {
        kdePackages = prev.kdePackages // {
          plasma-bigscreen = prev.kdePackages.plasma-bigscreen.overrideAttrs (old: {
            buildInputs = (old.buildInputs or [ ]) ++ [ prev.kdePackages.kdeconnect-kde ];
            preFixup = ''
              wrapQtApp $out/bin/plasma-bigscreen-wayland \
                --prefix QML2_IMPORT_PATH : "${prev.kdePackages.kdeconnect-kde}/lib/qt-6/qml"
            '';
          });
        };
      })
    ];

    environment.systemPackages = with pkgs; [
      kdePackages.plasma-bigscreen
    ];
  };
}
