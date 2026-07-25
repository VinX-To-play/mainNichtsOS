{config, ...}:{
  flake.nixosModules.cpp = {...}: {
    home-manager.sharedModules = [ config.flake.homeModules.cpp ];
    };
  }
