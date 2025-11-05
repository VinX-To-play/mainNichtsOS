{ pkgs, ... }: {
  services.nginx = {
    enable = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "v@lundborgs.de";
      server = "https://ca.slave.int/acme/acme/directory";
    };
    certs = {
      "slave.int" = {
        webroot = "/var/lib/acme/.well-known";
        postRun = "systemctl reload nginx";
      };
    };
  };

  users.users.nginx = {
    isSystemUser = true;
    createHome = false;
    home = "/var/lib/nginx";
    group = "nginx";
  };
  
}
