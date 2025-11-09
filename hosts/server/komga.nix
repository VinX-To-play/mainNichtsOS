{ config, ... }: {
  services.komga = {
    enable = true;
    settings.server.port = 8080;
  };
  
  services.nginx.virtualHosts."komga.slave.int" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.komga.settings.server.port}";
    };
  };
}
