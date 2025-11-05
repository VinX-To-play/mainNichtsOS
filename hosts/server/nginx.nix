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
  
}
