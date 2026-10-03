{ self, inputs, ...}: {

  flake.nixosModules.common-settings-de-only = { pkgs, lib, ... }: {
    # Enable portals
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
