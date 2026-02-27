{
  description = "NixOS configuration";

  nixConfig.extra-experimental-features = ["nix-command" "flakes"];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    stylix.url = "github:danth/stylix";
    hyprland.url = "github:hyprwm/Hyprland";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    sheard-host.url = "github:VinX-To-play/sheard-host-mirror";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # for AMDGPU Kernal patch for steamvr
    scrumpkgs = {
      url = "github:Scrumplex/pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # for more up to date vr packages
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-stable, home-manager, sops-nix, sheard-host, nixpkgs-xr, nixos-hardware,  ... }:
    let
      system = "x86_64-linux";
      
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
            { nixpkgs.overlays = [ stableOverlay nixpkgs-xr.overlays.default ]; }
            ./hosts/main_desktop/configuration.nix
            inputs.stylix.nixosModules.stylix
            sops-nix.nixosModules.sops
            sheard-host.nixosModules.sheardHosts
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
            { nixpkgs.overlays = [ stableOverlay ]; }
            ./hosts/ThinkPad/configuration.nix
            sheard-host.nixosModules.sheardHosts
            sops-nix.nixosModules.sops
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
        nichtsos-thinkpad-T14 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # pkgs.stable overlay
            { nixpkgs.overlays = [ stableOverlay ]; }
            ./hosts/T14/configuration.nix
            sheard-host.nixosModules.sheardHosts
            sops-nix.nixosModules.sops
            inputs.stylix.nixosModules.stylix
            nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.users.vincentl = import ./hosts/T14/home.nix;
              home-manager.sharedModules = [
                inputs.nixvim.homeModules.nixvim
              ];
            }
          ];
        };
        nix-server = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # pkgs.stable overlay
            { nixpkgs.overlays = [ stableOverlay ]; }
            ./hosts/server/configuration.nix
            sops-nix.nixosModules.sops
            inputs.stylix.nixosModules.stylix
            sheard-host.nixosModules.sheardHosts
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.users.vincentl = import ./hosts/server/home.nix;
              home-manager.sharedModules = [
                inputs.nixvim.homeModules.nixvim
              ];
            }
          ];
        };
      };
    };
}
