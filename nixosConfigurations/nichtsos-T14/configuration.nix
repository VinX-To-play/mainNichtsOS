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
	# TODO move to nixvim
    home-manager.sharedModules = [ self.homeModules.thinkpad-T14 ];

    networking.hostName = "nichtsos-thinkpad-T14";

    system.stateVersion = "23.11";
	
  };

  flake.homeModules.thinkpad-T14 = {...}: {
    imports = [ 
	../../kickstart.nixvim/nixvim.nix 
  	inputs.nixvim.homeModules.nixvim
	];
    home.stateVersion = "23.11";
  };
}
