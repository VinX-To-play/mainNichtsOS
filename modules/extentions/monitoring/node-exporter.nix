{...}:{

  flake.nixosModules.server = {lib, config, ...}: {
    options.vinlabs.promethus-exporters = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of exportes automaticly added to the promethus";
    };

    services.promethus = {
      exporters = {
        node = {
          enable = true;
          enableCollectors = [ "systemd" ];
          port = 9999;
        };
      };
    };

    vinlabs.promethus-exportes = [ 
      "${config.networking.hostName}:${toString config.services.promethus.exporters.node.port}"
    ];
  };
}
