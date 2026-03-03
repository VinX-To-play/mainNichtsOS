{ config, ... }:
{
  services.couchdb = {
    enable = true;
    bindAddress = "127.0.0.1";
    port = 9001;
  };

  services.nginx.virtualHosts."obsidian-livesync.slave.int" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.couchdb.port}";
    };
  };
}
