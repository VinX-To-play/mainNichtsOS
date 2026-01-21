{config, lib, ...}:
{
  services.prowlarr = {
    enable = true;
    settings = {
      server = {
        urlbase = "";
        port = 9696;
        bindaddress = "127.0.0.1";
      };
    };
  };
  
  services.nginx.virtualHosts."prowlarr.slave.int" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      basicAuthFile = config.sops.templates."nginx-auth".path;
      proxyPass = "http://127.0.0.1:${toString config.services.prowlarr.settings.server.port}";
    };
  };

  services.lidarr = {
    enable = true;
    settings = {
      server = {
        urlbase = "";
        port = 8686;
        bindaddress = "127.0.0.1";
      };
    };
  };

  
  services.nginx.virtualHosts."lidarr.slave.int" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      basicAuthFile = config.sops.templates."nginx-auth".path;
      proxyPass = "http://127.0.0.1:${toString config.services.lidarr.settings.server.port}";
    };
  };
  
  sops.templates."nginx-auth" = {
    content = ''
      vincent:${config.sops.placeholder."services/basicAuth/vincent"}
      '';
    owner = config.services.nginx.user;
    group = config.services.nginx.group;
  };

  sops.secrets."services/basicAuth/vincent" = {
  };



}

