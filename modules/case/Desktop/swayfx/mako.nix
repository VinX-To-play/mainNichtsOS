{config, ...}: {
  flake.nixosModules.mako = {...}: {
    home-manager.sharedModules = [ config.flake.homeModules.mako ];
  };

  flake.homeModules.mako = {pkgs, ...}: {
    services.mako = {
      enable = true;
      package = pkgs.mako;
      settings = {
        actions = true;
        icons = true;
        markup = true;
        layer = "top";
        default-timeout = 5000;
        border-radius = 30;
      };
    };
  };
}
