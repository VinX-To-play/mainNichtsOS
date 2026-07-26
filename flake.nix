{
  description = "NixOS configuration";

  # TODO remove
  # nixConfig.extra-experimental-features = ["nix-command" "flakes"];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    import-tree.url = "github:denful/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
    # for AMDGPU Kernal patch for steamvr
    scrumpkgs = {
      url = "github:Scrumplex/pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # for more up to date vr packages
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    

  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({ lib, ... }: {
      imports = [
        inputs.flake-parts.flakeModules.modules
        ./nixosConfigurations/nichtsos-T14/configuration.nix
        ./nixosConfigurations/nix-server-one/configuration.nix
        (inputs.import-tree.filter (lib.hasSuffix ".nix") ./modules )
      ];

      systems = [
        "x86_64-linux"
      ];
    }
    );
}
