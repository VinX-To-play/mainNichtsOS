{...}: {
  flake.nixosModules.tandoor = {pkgs, config, ...}: {
    services.tandoor-recipes = {
      enable = true;
      package = pkgs.tandoor-recipes;
      user = "tandoor_recipes";
      port = 4700;
      database.createLocally = true;
      extraConfig = {
        ENABLE_SIGNUP = "1";
        ALLOWED_HOSTS = "cookbook.slave.int";
        MEDIA_ROOT = "/var/lib/tandoor-recipes/mediafiles";
      };
    };


    # Injecting Secret Key from SOPS
    systemd.services.tandoor-recipes.serviceConfig.EnvironmentFile =
  config.sops.templates."tandoor-env".path;

    sops.templates."tandoor-env" = {
      content = ''
        SECRET_KEY=${config.sops.placeholder."services/tandoor/key"}
      '';
    };

    sops.secrets."services/tandoor/key" = {
      # user = config.services.tandoor-recipes.user;
    };

    # NGINX CONFIG STUFF
    users.groups.tandoor_recipes.members = [ "nginx" ];
    services.nginx.virtualHosts."cookbook.slave.int" = {
      enableACME = true;
      forceSSL = true;

      locations = {
        "/" = {
          proxyPass = "http://localhost:${ toString config.services.tandoor-recipes.port}";
          proxyWebsockets = true;
        };

        "/media/".alias = "/var/lib/tandoor-recipes/mediafiles/";
      };
    };
    
  };
}
