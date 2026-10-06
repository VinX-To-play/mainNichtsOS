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
            BOOKLORE_HOST = "books.${baseurl}";
            BOOKLORE_USER = "shelfmark";
          };
        };

        systemd.services.shelfmark.serviceConfig = {
          EnviromentFile  = config.sops.templates."shelfmark-env.conf".path;
        };

        sops.secrets."services.shelfmark.bookpas" = {};

        sops.templates."shelfmark-env.conf".content = ''
          BOOKLORE_PASSWORD = ${config.sops.placeholder."services.shelfmark.bookpas"}
        '';

        services.nginx.virtualHosts."bookadd.${baseurl}" = {
          useACMEHost = "${baseurl}";
          forchSSL = true;
          locations."/" = {
            proxyPass = "http://${cfg.enviroment.FLASK_HOST}:${cfg.enviroment.FLASK_PORT}";
          };
        };
    };
}
