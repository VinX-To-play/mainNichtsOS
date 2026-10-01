{config, ...}:{
  flake.nixosModules.books =
    let
      baseurl = config.flake.meta.baseurl;

    in {config, ...}:
    let
      cfg = config.services.shelfmark;
    in {

        services.shelfmark = {
          enable = true;
          environment = {
            FLASK_HOST = "127.0.0.1";
            FLASK_PORT = "6667";
            LOG_LEVEL = "DEBUG";
            SEARCH_MODE = "universal";
          };
        };

        services.nginx.virtualHosts."bookadd.${baseurl}" = {
          useACMEHost = "${baseurl}";
          forchSSL = true;
          locations."/" = {
            proxyPass = "http://${cfg.enviroment.FLASK_HOST}:${cfg.enviroment.FLASK_PORT}";
          };
        };
    };
}
