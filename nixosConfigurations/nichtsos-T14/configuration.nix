{ self, inputs, ... }:
{
  flake.nixosConfigurations.nichtsos-thinkpad-T14 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      self.nixosModules.base
      self.nixosModules.thinkpad-T14
      self.nixosModules.Desktop

      ./_hardware-configuration.nix
    ];

  };

  flake.nixosModules.thinkpad-T14 = 
  { ... }:
  {
    home-manager.sharedModules = [ self.homeModules.thinkpad-T14 ];

    system.stateVersion = "23.11";
  };

  flake.homeModules.thinkpad-T14 = {...}: {
    home.stateVersion = "23.11";
  };
}
