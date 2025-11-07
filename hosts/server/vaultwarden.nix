{ config, pkgs, ... }: {
services.vaultwarden = {
  enable = true;  
  backupDir = "/var/backup/vaultwarden";
  environmentFile = "/run/secrets/services/vaultwarden/envFile";
  config = {
    DOMAIN = "https://vaultwarden.slave.int";
    SIGNUPS_ALLOWED = false;

    ROCKET_ADDRESS = "127.0.0.1";
    ROCKET_PORT = 8222;

    ROCKET_LOG = "critical";

    SMTP_HOST = "smtp.gmail.com";
    SMTP_PORT = 587;
    SMTP_SECURITY = "starttls";
    SMTP_FROM = "ichdincool@gmail.com";
    SMTP_USERNAME = "ichdincool@gmail.com";

    HELO_NAME = "NixOS Server";

    };
  };

  users.users.vautwarden = {
    isSystemUser = true;
    description = "Vautwarden service user";
    createHome = false;
    home = "/var/lib/vaultwarden";
    group = "vaultwarden";
  };

  
  sops.secrets."services/vaultwarden/envFile" = {
    owner = "vaultwarden";
    group = "vaultwarden";
  };

  services.nginx.virtualHosts."vaultwarden.slave.int" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        proxyWebsockets = true;
    };
  };
}
