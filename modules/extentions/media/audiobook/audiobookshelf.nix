{config, ...}:{
  flake.nixosModules.audiobooks =
    let
      baseurl = config.flake.meta.baseurl;
    in
    {config, ...}:
    let
      abs = config.services.audiobookshelf;
    in {
    services.audiobookshelf = {
      enable = true;
      host = "0.0.0.0";
      port = 4001;
    };

    services.nginx.virtualHosts."audiobooks.${baseurl}" = {
      forceSSL = true;
      useACMEHost = "${baseurl}";
      locations."/" = {
        proxyPass = "http://${abs.host}:${toString abs.port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_redirect http:// $scheme://;
        '';
      };
    };
  };
}
