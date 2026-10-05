{ self, inputs, ... }:
{

  flake.nixosConfigurations.nichtsos-main = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = with self.nixosModules; [
      base
      nichtsos-main
      Desktop
      amd
      gaming
      cpp
      ts-js
      vr
      logitech-mouse
   ] ++ [
      ./_hardware-configuration.nix
    ];

  };

  flake.nixosModules.nichtsos-main = 
  {pkgs, ... }:
  {
	# TODO move to nixvim
    home-manager.sharedModules = [ self.homeModules.nichtsos-main ];

    networking = {
      hostName = "nichtsos-main";
      nameservers = [
	"192.168.1.201"
	"1.1.1.1"
      ];
      firewall.allowedTCPPorts = [
	  22
	  8000
	];
      defaultGateway = "192.168.1.1";
      interfaces.enp7s0 = {
	wakeOnLan = {
	  enable = true;
	  policy = [ "magic" ];
	};
	
	ipv4.addresses = [{
	  address = "192.168.1.2";
	  prefixLength = 24;
	}];
      };
    };

    system.stateVersion = "23.11";


    environment.systemPackages = with pkgs; [
      #nrealDriver # TODO remove move to integrated lib
      nrealAirLinuxDriver
    ];

    services.udev.packages = [pkgs.nrealAirLinuxDriver];
	
  };

  flake.homeModules.nichtsos-main = {...}: {
    imports = [ 
	../../kickstart.nixvim/nixvim.nix 
  	inputs.nixvim.homeModules.nixvim
	];
    home.stateVersion = "24.05";
  };
}
