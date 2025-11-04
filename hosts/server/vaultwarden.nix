{ config, pkgs, ... }: {
services.vaultwarden = {
  enable = true;  
  backupDir = "/var/backup/vaultwarden";
  environmentFile = "/run/secrets/services/vaultwarden/";
  config = {
    DOMAIN = "https://bitwarden.slave.int";
    SIGNUPS_ALLOWED = false;

    ROCKET_ADDRESS = "127.0.0.1";
    ROCKET_PORT = 8222;

    ROCKET_LOG = "critical";
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

  #services.nginx.virtualHosts."vaultwarden.slave.int" = {
  #  enableACME = false;
  #  forceSSL = true;
  #  locations."/" = {
  #      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
  #  };
  #};
}
