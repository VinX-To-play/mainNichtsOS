{...}:
{
  flake.nixosModules.monitoringHost = {config, lib, ...}:{
    services.prometheus = {
      exporters.opnsense = {
        enable = true;
        user = "opnsense";
        opnsenseServerAddress = "192.168.1.1";
        opnsenseServerProtocol = "http";
        extraFlags = [
          "--opnsense.insecure"
          "--exporter.instance-label Main"
        ];
      };

      scrapeConfigs = [
        {
          job_name = "OPNsense-OS-exporter";
          static_configs = [{
            targets = ["192.168.1.1:5005"];
          }];
        }
        {
          job_name = "OPNsense-API-exporter";
          static_configs = [{
            targets = ["localhost:${toString config.services.prometheus.exporters.opnsense.port}"];
          }];
        }
      ];
    };

    sops.secrets."opnsense/apiKey" = {
    };
    sops.secrets."opnsense/apiSecret" = {
    };

    sops.templates."opnsense-exporter.env" = {
      content = ''
        OPNSENSE_EXPORTER_OPS_API_KEY=${config.sops.placeholder."opnsense/apiKey"}
        OPNSENSE_EXPORTER_OPS_API_SECRET=${config.sops.placeholder."opnsense/apiSecret"}
        '';
      owner = "root";
      mode = "0400";

      restartUnits = [ "prometheus-opnsense-exporter.service" ];
    };
    systemd.services.prometheus-opnsense-exporter = {
      # requires = [ "sops-nix.service" ];
      # after = [ "sops-nix.service" ];
      serviceConfig.EnvironmentFile = config.sops.templates."opnsense-exporter.env".path;
    };
  };
}
