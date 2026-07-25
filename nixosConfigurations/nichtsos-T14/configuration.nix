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
      gaming
      cpp
   ] ++ [
      ./_hardware-configuration.nix
    ];

  };

  flake.nixosModules.thinkpad-T14 = 
  {pkgs, ... }:
  {
	# TODO move to nixvim
    home-manager.sharedModules = [ self.homeModules.thinkpad-T14 ];

    imports = [ inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1 ];

    networking.hostName = "nichtsos-thinkpad-T14";

    system.stateVersion = "23.11";


    environment.systemPackages = with pkgs; [
      #nrealDriver # TODO remove move to integrated lib
      nrealAirLinuxDriver
    ];

    services.udev.packages = [pkgs.nrealAirLinuxDriver];
	
  };

  flake.homeModules.thinkpad-T14 = {...}: {
    imports = [ 
	../../kickstart.nixvim/nixvim.nix 
  	inputs.nixvim.homeModules.nixvim
	];
    home.stateVersion = "23.11";
  };
}
