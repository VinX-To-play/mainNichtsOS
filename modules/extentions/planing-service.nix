{config, ...}: {
  flake.nixosModules.planing-service = 
    let
      baseurl = config.flake.meta.baseurl;
      hostname = "planer.${baseurl}";
      port = 5005;
    in {...}: {
      services.vikunja = {
        enable = true;
        frontendScheme = "https";
        frontendHostname = hostname;
        port = port;
      };
      services.nginx.virtualHosts.${hostname} = {
        useACMEHost = "${baseurl}";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://[::1]:${toString port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 5000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
      };
      };
}
