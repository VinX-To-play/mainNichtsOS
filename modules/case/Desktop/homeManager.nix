{config,...}: {
  flake.nixosModules.Desktop = {
    home.sheardModules = [ config.flake.homeModules.Desktop ];
  };
}
