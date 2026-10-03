{self, inputs, ...}: {

  flake.nixosConfigurations.Falcon = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.FalconConfig
    ];
  };
}
