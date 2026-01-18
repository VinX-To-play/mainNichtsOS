{config, ...}:
{
  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/srv/shared/music"; 
      Address = "127.0.0.1";
      Port = "8224";
    };
  };
  
  services.nginx.virtualHosts."navidrome.slave.int" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
        proxyPass = "${toString config.services.navidrome.settings.Address}:${toString config.services.navidrome.settings.Port}";
        proxyWebsockets = true;
    };
  };
}
