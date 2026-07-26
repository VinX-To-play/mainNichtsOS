{...}: {
  flake.nixosModules.komga = {...}: {
    services.komga = {
      enable = true;
      port = 9000;
      settings.server.port = 9000;
    };

    services.nginx.virtualHosts."komga.slave.int" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:9000";
        };
      };
    };
}
