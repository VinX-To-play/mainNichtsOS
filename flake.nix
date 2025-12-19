{
  description = "NixOS configuration";

  nixConfig.extra-experimental-features = ["nix-command" "flakes"];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    stylix.url = "github:danth/stylix";
    hyprland.url = "github:hyprwm/Hyprland";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    # sheard-host.url = "git+ssh://gitea@gitea.yggdrasil.com/vinx/Shared-Intranet-Host.git?ref=main";
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
  };

  outputs = inputs@{ nixpkgs, nixpkgs-stable, home-manager, sops-nix, ... }:
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
            { nixpkgs.overlays = [ stableOverlay  ]; }
            ./hosts/main_desktop/configuration.nix
            inputs.stylix.nixosModules.stylix
            sops-nix.nixosModules.sops
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
            # sheard-host.nixosModules.sheardHosts
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
        nix-server = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # pkgs.stable overlay
            { nixpkgs.overlays = [ stableOverlay ]; }
            ./hosts/server/configuration.nix
            sops-nix.nixosModules.sops
            inputs.stylix.nixosModules.stylix
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
