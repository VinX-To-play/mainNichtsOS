{config, ...}:{
  flake.nixosModules.ts-js = {...}: {
    home-manager.sharedModules = [ config.flake.homeModules.ts-js ];
    };
  }
