{ config, pkgs, ... }: {
services.vaultwarden = {
  enable = true;  
  backupDir = "/var/backup/vaultwarden";
  environmentFile = config.sops.templates."vaultwarden.env".path;
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

      # HELO_NAME = "NixOS Server";

    };
  };

  users.users.vautwarden = {
    isSystemUser = true;
    description = "Vautwarden service user";
    createHome = false;
    home = "/var/lib/vaultwarden";
    group = "vaultwarden";
  };

  sops.templates."vaultwarden.env" = {
    content = ''
    ADMIN_TOKEN=${config.sops.placeholder."services/vaultwarden/envFile/adminToken"}
    SMTP_PASSWORD=${config.sops.placeholder."services/vaultwarden/envFile/smtpPassword"}
    '';
    owner = "vaultwarden";
  };
  
  sops.secrets."services/vaultwarden/envFile/adminToken" = {
  };
  
  sops.secrets."services/vaultwarden/envFile/smtpPassword" = {
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
