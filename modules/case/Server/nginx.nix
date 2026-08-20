{...}: {
  flake.nixosModules.server = {...}:{
    services.nginx = {
      enable = true;
      defaultListenAddresses = [ "0.0.0.0"  ];
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
    };

    networking.firewall.allowedTCPPorts = [ 443 80 ];

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
  };
}
