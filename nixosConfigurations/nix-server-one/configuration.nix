{ self, inputs, ... }:
{

  flake.nixosConfigurations.nix-server-one = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = with self.nixosModules; [
      base
      amd

      server

      vaultwarden
      ca
      komga

      nix-server-one
   ] ++ [
      ./_hardware-configuration.nix
    ];

  };

  flake.nixosModules.nix-server-one = 
  {pkgs,lib, ... }:
  {
    home-manager.sharedModules = [ self.homeModules.nix-server-one ];


    networking = {
      hostName = "nix-server-one";
      defaultGateway = "192.168.1.1";
      nameservers = ["192.168.1.201"];
      interfaces = { 
        ens18.ipv4.addresses = [{
          address = "192.168.1.205";
          prefixLength = 24;
        }];
      };
    };

    boot.loader = {
      systemd-boot.enable = lib.mkForce false;
      grub = {
	enable = lib.mkForce true;
	device = "/dev/sda/";
    	useOSProber = true;
      };
    };


    system.stateVersion = "25.05";


    environment.systemPackages = with pkgs; [
    ];

	
  };

  flake.homeModules.nix-server-one = {...}: {
    imports = [ 
	../../kickstart.nixvim/nixvim.nix 
  	inputs.nixvim.homeModules.nixvim
	];
    home.stateVersion = "25.05";
  };
}
