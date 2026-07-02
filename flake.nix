{
  description = "NixOS configuration";

  nixConfig.extra-experimental-features = ["nix-command" "flakes"];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
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
    };
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    scrumpkgs = {
      url = "github:Scrumplex/pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    import-tree.url = "github:denful/import-tree";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-stable, home-manager, sops-nix, sheard-host, nixpkgs-xr, nixos-hardware, ... }:
    let
      system = "x86_64-linux";

      stableOverlay = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      treeModules = inputs.import-tree.matchNot ".*/llama-cpp\\.nix" ./modules;
    in {
      nixosConfigurations = {
        nichtsos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ stableOverlay nixpkgs-xr.overlays.default ]; }
            treeModules
            ./modules/extensions/_llama-cpp.nix
            ./nixosConfigurations/nichtsos/nixos.nix
            sheard-host.nixosModules.sheardHosts
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vincentl = {};
              home-manager.sharedModules = [ inputs.nixvim.homeModules.nixvim ];
            }
          ];
        };

        nichtsos-thinkpad = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ stableOverlay ]; }
            treeModules
            ./nixosConfigurations/nichtsos-thinkpad/nixos.nix
            sheard-host.nixosModules.sheardHosts
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vincentl = {};
              home-manager.sharedModules = [ inputs.nixvim.homeModules.nixvim ];
            }
          ];
        };

        nichtsos-thinkpad-T14 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ stableOverlay ]; }
            treeModules
            ./nixosConfigurations/nichtsos-thinkpad-T14/nixos.nix
            sheard-host.nixosModules.sheardHosts
            nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vincentl = {};
              home-manager.sharedModules = [ inputs.nixvim.homeModules.nixvim ];
            }
          ];
        };

        nix-server = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ stableOverlay ]; }
            treeModules
            ./nixosConfigurations/nix-server/nixos.nix
            sheard-host.nixosModules.sheardHosts
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vincentl = {};
              home-manager.sharedModules = [ inputs.nixvim.homeModules.nixvim ];
            }
          ];
        };
      };
    };
}
