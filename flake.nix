{
  description = "NixOS configuration";
  
  nixConfig.extra-experimental-features = ["nix-command"" flakes"];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix?ref=b00c9f46ae6c27074d24d2db390f0ac5ebcc329f";
    nixvim = {
    	url = "github:nix-community/nixvim";
	    inputs.nixpkgs.follows = "nixpkgs";
	  };
    # home-manager, used for managing user configuration
     home-manager = {
      url = "github:nix-community/home-manager/";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
       };
   };


  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      nichtsos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs; };
        modules = [
          ./hosts/main_desktop/configuration.nix
          inputs.stylix.nixosModules.stylix
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager {
             home-manager.useGlobalPkgs = true;
             home-manager.useUserPackages = true;

             home-manager.users.vincentl = import ./hosts/main_desktop/home.nix;
	           home-manager.sharedModules = [
	              inputs.nixvim.homeManagerModules.nixvim
	            ];
             # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };

      ThinkPad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/ThinkPad/configuration.nix
          inputs.stylix.nixosModules.stylix
          #make anyrun avaylebil for all users
          #{environment.systemPackages = [ anyrun.packages.${system}.anyrun ];}
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager {
             home-manager.useGlobalPkgs = false;
             home-manager.useUserPackages = true;

             # TODO replace ryan with your own username
             home-manager.users.vincentl = import ./hosts/ThinkPad/home.nix;
	           home-manager.sharedModules = [
	           	inputs.nixvim.homeManagerModules.nixvim
	          ];
             # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}
