{ self, inputs, ... }:
{
  flake.nixosConfigurations.nichtsos-thinkpad-T14 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = with self.nixosModules; [
      base
      thinkpad-T14
      Desktop
      amd
   ] ++ [
      ./_hardware-configuration.nix
    ];

  };

  flake.nixosModules.thinkpad-T14 = 
  { ... }:
  {
    home-manager.sharedModules = [ self.homeModules.thinkpad-T14 ];

    networking.hostName = "nichtsos-thinkpad-T14";

    system.stateVersion = "23.11";
	
     services.desktopManager.plasma6.enable = true;
  };

  flake.homeModules.thinkpad-T14 = {...}: {
    imports = [ ../../kickstart.nvim/nixvim.nix ];
    home.stateVersion = "23.11";
  };
}
