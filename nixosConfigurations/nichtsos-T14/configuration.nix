{ self, inputs, ... }:
{
  flake.nixosConfigurations.nichtsos-thinkpad-T14 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      self.nixosModules.base
      self.nixosModules.thinkpad-T14

      ./_hardware-configuration.nix
    ];

  };

  flake.nixosModules.thinkpad-T14 = 
  { ... }:
  {
    system.stateVersion = "23.11";
  };
}
