{config, ...}:
let
    baseurl = config.flake.meta.baseurl;
    serverTagets = config.vinlabs.prometheus-exporters;
in {
  flake.nixosModules.monitoringHost = {pkgs, config, ...}:
    let 
      grafanaDomain = "grafana.${baseurl}";
    in  {
    services.prometheus = {
      enable = true;
      port = 5005;

      scrapeConfigs = [
        {
            job_name = "node-exporters";
            static_configs = [{
              targets = serverTagets;
          }
          ];
        }
      ];
    };


    # Grapha
    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 5004;
          enforce_domain = false;
          enable_gzip = true;
          domain = "${grafanaDomain}";
          root_url = "https://${grafanaDomain}/";
          protocol = "http";
        };
        security = {
          secret_key = "$__file{${config.sops.secrets."services/grafana/secretsKey".path}}";
        };
        analytics.reporting_enabled = false;
      };

      # Plugins
      declarativePlugins = with pkgs.grafanaPlugins; [ grafana-piechart-panel ];

      provision = {
        enable = true;

        datasources.settings.datasources = [{
          name = "Prometheus";
          type = "prometheus";
          uid = "PBFA97CFB590B2093";
          url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
          isDefault = true;
          editable = false;
        }];


      };
    };

    sops.secrets."services/grafana/secretsKey" = {
      owner = "grafana";
      group = "grafana";
    };

    services.nginx.virtualHosts."${grafanaDomain}" = {
        forceSSL = true;
        useACMEHost = "${baseurl}";
        locations."/" = {
          proxyPass = "http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
     };
  };
}
