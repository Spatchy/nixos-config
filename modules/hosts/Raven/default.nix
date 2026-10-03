{self, inputs, ...}: {

  flake.nixosConfigurations.Raven = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.RavenConfig
    ];
  };
}
