{ pkgs, ... }: {
  services.nginx = {
    enable = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "v@lundborgs.de";
      server = "https://ca.slave.int:8443/acme/acme/directory";
    };
  };

  users.users.nginx = {
    isSystemUser = true;
    createHome = false;
    home = "/var/lib/nginx";
    group = "nginx";
  };
  
}
