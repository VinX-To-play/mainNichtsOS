{config, ...}:{
  flake.nixosModules.books =
    let
      baseurl = config.flake.meta.baseurl;

    in {config, pkgs, ...}:
    let
      cfg = config.services.shelfmark;
    in {

        services.shelfmark = {
          enable = true;
          package = pkgs.shelfmark.overrideAttrs (oldAttrs: {
            propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or []) ++ [
              pkgs.python3Packages.httpx
            ];
          });
          environment = {
            FLASK_HOST = "127.0.0.1";
            FLASK_PORT = 6667;
            LOG_LEVEL = "DEBUG";
            SEARCH_MODE = "universal";
            BOOKLORE_HOST = "books.${baseurl}";
            BOOKLORE_USER = "shelfmark";
          };
        };

        systemd.services.shelfmark.serviceConfig = {
          EnvironmentFile  = config.sops.templates."shelfmark-env.conf".path;
          RuntimeDirectory = "shelfmark";
          WorkingDirectory = "/run/shelfmark";
        };

        sops.secrets."services/shelfmark/bookshelfPas" = {};

        sops.templates."shelfmark-env.conf".content = ''
          BOOKLORE_PASSWORD = ${config.sops.placeholder."services/shelfmark/bookshelfPas"}
        '';

        services.nginx.virtualHosts."bookadd.${baseurl}" = {
          forceSSL = true;
          useACMEHost = "${baseurl}";
          locations."/" = {
            proxyPass = "http://${cfg.environment.FLASK_HOST}:${toString cfg.environment.FLASK_PORT}";
          };
        };
    };
}
