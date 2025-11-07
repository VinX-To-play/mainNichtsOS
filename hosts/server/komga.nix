{ config, ... }: {
  services.komga = {
    enable = true;
    settings.port = 512;
  };
  
  services.nginx.virtualHosts."komga.slave.int" = {
    enableACME = true;
    forceSSL = false;

    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.komga.settings.port}";
    };
  };
}
