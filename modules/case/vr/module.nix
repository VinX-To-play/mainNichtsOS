{config, ... }: {
  flake.nixosModules.vr = {...}: {
    home-manager.sharedModules = [config.flake.homeModules.vr ];
  };
}
