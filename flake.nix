{
  description = "NixOS configuration";

  nixConfig.extra-experimental-features = ["nix-command" "flakes"];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    stylix.url = "github:danth/stylix";
    hyprland.url = "github:hyprwm/Hyprland";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, nixpkgs-stable, home-manager, ... }:
    let
      system = "x86_64-linux";
      
      sheardOverlay = (import ./Overlays/spotify-player-auth-fix.nix);

      # Ovalay helperfunction for pkgs.stable
      stableOverlay = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        nichtsos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # add stable Ovalay 
            { nixpkgs.overlays = [ stableOverlay  ]; }
            ./hosts/main_desktop/configuration.nix
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.users.vincentl = import ./hosts/main_desktop/home.nix;
              home-manager.sharedModules = [
                inputs.nixvim.homeModules.nixvim
              ];
            }
          ];
        };

        nichtsos-thinkpad = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # pkgs.stable overlay
            { nixpkgs.overlays = [ stableOverlay sheardOverlay ]; }
            ./hosts/ThinkPad/configuration.nix
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.users.vincentl = import ./hosts/ThinkPad/home.nix;
              home-manager.sharedModules = [
                inputs.nixvim.homeModules.nixvim
              ];
            }
          ];
        };
      };
    };
}
