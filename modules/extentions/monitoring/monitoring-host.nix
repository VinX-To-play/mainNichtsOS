{config, ...}:
let
    baseurl = config.flake.meta.baseurl;
in {
  flake.nixosModules.monitoringHost = {pkgs, config, ...}:
    {
    services.prometheus = {
      enable = true;
      port = 5005;

      scrapeConfigs = [
          {
            job_name = "node-exporters";
            static_configs = [{
              targets = config.vinlabs.promethus-exporters;
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
          enforce_domain = true;
          enable_gzip = true;
          domain = "grafana.${baseurl}";
        };
      };

      # Plugins
      declarativePlugins = with pkgs.grafanaPlugins; [ grafana-piechart-panel ];

      provision = {
        enable = true;

      };

      analytics.reporting.enable = false;
    };

    services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} = {
        forceSSL = true;
        addSSL = true;
        useACMEHost = "${baseurl}";
        locations."/" = {
          proxyPass = "${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host ${config.services.grafana.settings.server.domain};
          '';
        };
     };
  };
}
