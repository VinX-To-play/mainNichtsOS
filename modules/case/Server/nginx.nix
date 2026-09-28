{...}: {
  flake.nixosModules.server = {config, ...}:{
    services.nginx = {
      enable = true;
      defaultListenAddresses = [ "0.0.0.0"  ];
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
    };

    networking.firewall.allowedTCPPorts = [ 443 80 ];
    
    sops.secrets."services/cloudflare-acme/key" = {
      owner = "acme";
      group = "acme";
      mode = "0400";
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "v@lundborgs.de";
        server = "https://ca.slave.int:8443/acme/acme/directory";
      };

      certs."elin.love" = {
        group = "nginx";
        server = "https://acme-v02.api.letsencrypt.org/directory";  
        domain = "*.elin.love";

        dnsProvider = "cloudflare";

        credentialFiles = {
          "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets."services/cloudflare-acme/key".path;
        };
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
