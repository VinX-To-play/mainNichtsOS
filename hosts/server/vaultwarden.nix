{ config, pkgs, ... }: {
services.vaultwarden = {
  enable = true;  
  backupDir = "/var/backup/vaultwarden";
  environmentFile = "/run/secrets/services/vaultwarden/env-file";
  config = {
    DOMAIN = "https://bitwarden.slave.int";
    SIGNUPS_ALLOWED = false;

    ROCKET_ADDRESS = "127.0.0.1";
    ROCKET_PORT = 8222;

    ROCKET_LOG = "critical";
    };
  };

  users.users.vautwardenservice = {
    isSystemUser = true;
    description = "Vautwarden service user";
    createHome = false;
    home = "/var/lib/vaultwarden";
    shell = pkgs.runCommandNoCC "nologin" {} "";
    group = "vaultwardenservice";
  };
  
  sops.secrets."services/vaultwarden/env-file" = {
    format = "dotenv";
    owner = "vaultwardenservice";
    group = "vaultwardenservice";
  };

  services.nginx.virtualHosts."vaultwarden.slave.int" = {
    enableACME = false;
    forceSSL = true;
    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
    };
  };
}
