{ self, inputs, ...}: {
  flake.nixosModules.blender = { pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
      (
        (pkgs.blender.override {
          config.rocmSupport=true;
          config.cudaSupport=false;
        }).withPackages(ps: [
          ps.yq
        ])
      )
    ];
  };
}
