{ config, ... }:
let
  baseurl        = config.flake.meta.baseurl;
  containerName  = "vaultwarden";
  hostAddress    = "10.100.0.1";
  localAddress   = "10.100.0.2";
  vaultwardenPort = 8222;

  # Fixed IDs so ownership lines up across the bind mount.
  vaultwardenUid = 995;
  vaultwardenGid = 993;

  dataDir = "/var/lib/nixos-containers/vaultwarden/data";
in
{
  flake.nixosModules.vaultwarden = { config, ... }: {
    # ----------------------------------------------------------------
    # 1. Create the user ON THE HOST (needed for sops chown + tmpfiles)
    # ----------------------------------------------------------------
    users.users.vaultwarden = {
      isSystemUser = true;
      uid = vaultwardenUid;
      group = "vaultwarden";
      home = "/var/lib/vaultwarden";   # never used, just for completeness
      createHome = false;
    };
    users.groups.vaultwarden.gid = vaultwardenGid;

    # ----------------------------------------------------------------
    # 2. Secrets (host-side, owned by vaultwarden:vaultwarden)
    # ----------------------------------------------------------------
    sops.secrets."services/vaultwarden/envFile/adminToken" = { };
    sops.secrets."services/vaultwarden/envFile/smtpPassword" = { };

    sops.templates."vaultwarden.env" = {
      content = ''
        ADMIN_TOKEN=${config.sops.placeholder."services/vaultwarden/envFile/adminToken"}
        SMTP_PASSWORD=${config.sops.placeholder."services/vaultwarden/envFile/smtpPassword"}
      '';
      owner = "vaultwarden";
      group = "vaultwarden";
    };

    # Make sure the persistent data dir exists with the right owner
    systemd.tmpfiles.rules = [
      "d ${dataDir} 0750 vaultwarden vaultwarden -"
    ];

    # ----------------------------------------------------------------
    # 3. Container
    # ----------------------------------------------------------------
    containers.${containerName} = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = hostAddress;
      localAddress = localAddress;

      bindMounts."/run/secrets/vaultwarden.env" = {
        hostPath = config.sops.templates."vaultwarden.env".path;
        isReadOnly = true;
      };
      bindMounts."/var/lib/vaultwarden" = {
        hostPath = dataDir;
        isReadOnly = false;
      };

      config = { pkgs, lib, config, ... }: {
        # IMPORTANT: force the SAME UID/GID inside the container.
        # The vaultwarden module creates this user; we only override the ids.
        users.users.vaultwarden = {
          isSystemUser = true;
          uid = vaultwardenUid;
          group = "vaultwarden";
        };
        users.groups.vaultwarden.gid = vaultwardenGid;

        services.vaultwarden = {
          enable = true;
          backupDir = "/var/backup/vaultwarden";
          environmentFile = "/run/secrets/vaultwarden.env";
          config = {
            DOMAIN = "https://vaultwarden.${baseurl}";
            SIGNUPS_ALLOWED = false;
            ROCKET_ADDRESS = "0.0.0.0";
            ROCKET_PORT = vaultwardenPort;
            ROCKET_LOG = "critical";
            SMTP_HOST = "smtp.gmail.com";
            SMTP_PORT = 587;
            SMTP_SECURITY = "starttls";
            SMTP_FROM = "ichdincool@gmail.com";
            SMTP_USERNAME = "ichdincool@gmail.com";
          };
        };

        networking.firewall.allowedTCPPorts = [ vaultwardenPort ];
        system.stateVersion = "24.05";
      };
    };

    # ----------------------------------------------------------------
    # 4. Host nginx → container IP
    # ----------------------------------------------------------------
    services.nginx.virtualHosts."vaultwarden.${baseurl}" = {
      forceSSL = true;
      useACMEHost = "${baseurl}";
      locations."/" = {
        proxyPass = "http://${localAddress}:${toString vaultwardenPort}";
        proxyWebsockets = true;
      };
    };
  };
}
