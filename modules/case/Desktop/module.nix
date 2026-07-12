{config, ... }: {
  flake.nixosModules.Desktop = {...}: {
    imports = with config.flake.nixosModules; [ swayfx ];
    # home-manager.sharedModules = [config.flake.homeModules.Desktop ];
  };
}
