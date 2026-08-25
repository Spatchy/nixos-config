{self, inputs, ...}: {

  flake.nixosConfigurations.Stork = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.StorkConfig
    ];
  };
}