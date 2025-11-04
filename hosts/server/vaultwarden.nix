{ config, ... }: {
services.vaultwarden = {
  enable = true;  
  backupDir = "/var/backup/vaultwarden";
  config = {
    DOMAIN = "https://bitwarden.slave.int";
    SIGNUPS_ALLOWED = false;

    ROCKET_ADDRESS = "127.0.0.1";
    ROCKET_PORT = 8222;

    ROCKET_LOG = "critical";
    };
  };

  services.nginx.virtualHosts."vaultwarden.slave.int" = {
    enableACME = false;
    forceSSL = true;
    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
    };
  };
}
