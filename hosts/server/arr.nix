{...}:
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
        proxyPass = "http://127.0.0.1:9000";
    };
  };

}

