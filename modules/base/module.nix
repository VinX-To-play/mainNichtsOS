{config, ... }: {
  flake.nixosModules.base = {...}: {
    home-manager.sharedModules = [config.flake.homeModules.base ];
  };
}
