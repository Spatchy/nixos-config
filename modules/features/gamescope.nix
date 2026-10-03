{self, inputs, ...}: {

  flake.nixosModules.gamescope = { pkgs, lib, ... }: {
    programs = {
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      steam.gamescopeSession.enable = true;
    };

    # Gamescope Auto Boot from TTY (example)
    services = {
      xserver.enable = false; # Assuming no other Xserver needed
      getty.autologinUser = "james";
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${lib.getExe pkgs.gamescope} -f -e --xwayland-count 2 --hdr-enabled --hdr-itm-enabled -- steam -pipewire-dmabuf -gamepadui -steamdeck -steamos3 > /dev/null 2>&1";
            user = "james";
          };
        };
      };
    };
  };
}
