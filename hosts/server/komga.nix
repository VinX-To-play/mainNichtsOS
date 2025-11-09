{ config, ... }: {
  
  services.komga = {
    enable = true;
    settings = {
      server = {
        port = 512;
      };
    };
  };
  
  services.nginx.virtualHosts."komga.slave.int" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
        proxyPass = "http://127.0.0.1:512";
    };
  };
}
