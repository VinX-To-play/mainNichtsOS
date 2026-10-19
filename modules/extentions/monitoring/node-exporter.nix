{...}:{
  flake.nixosModules.server = {config, ...}: {
    services.prometheus = {
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 9999; # dont change this is will brack server add in or change in servers configuration.nix file
        };
      };
    };
  };
}
