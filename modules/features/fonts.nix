{ self, inputs, ...}: {

  flake.nixosModules.fonts = { pkgs, lib, ... }: {
    fonts.packages = with pkgs; [
      lexend
      carlito
      tex-gyre.schola
    ];
  };
}