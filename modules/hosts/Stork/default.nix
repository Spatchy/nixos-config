{self, inputs, ...}: {

  flake.nixosConfigurations.Stork = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.StorkConfig
      inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
    ];
  };
}
