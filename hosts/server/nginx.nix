{ pkgs, ... }: {
  services.nginx = {
    enable = true;
  };
  
  sops.secrets."nginx-selfsigned.key" = {
    sopsFile = ./../../secrets/nginx/nginx-selfsigned.key;
    format = "binary";
    owner = "nginx";
    group = "nginx";
    };

  users.users.nginx = {
    isSystemUser = true;
    createHome = false;
    home = "/var/lib/nginx";
    group = "nginx";
  };
  
  services.nginx.virtualHosts."_" = {
    default = true;
    forceSSL = false;
    listen = [
     {
       addr = "0.0.0.0";
       port = 80;
     }
     {
       addr = "0.0.0.0";
       port = 443;
       ssl = true;
      }
    ];
    # Self‑signed cert just so SSL connections won’t break
    sslCertificate = ../../secrets/nginx/nginx-selfsigned.crt;
    sslCertificateKey = "/run/secrets/nginx-selfsigned.key";
    locations."/" = {
      return = "403"; # 444 = drop connection (no response)
  };
};
}
