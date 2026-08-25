{ self, inputs, ...}: {

  flake.nixosModules.desktop-apps = { pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      thunderbird
      obsidian
      nextcloud-client
      mpv
    ];
  };
}