{config, lib, ...}:
{
  services.searx = {
    enable = true;
    settings = {
      server = {
        port = 3333;
        bind_address = "172.0.0.1";
        #secret_key = "$SEARX_SECRET_KEY";
      };
    };
  };

  services.nginx.virtualHosts."search.slave.int" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://172.0.0.1:3333";
      extraConfig = "
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection \"upgrade\";
      proxy_read_timeout 180s;
      proxy_connect_timeout 180s;
        ";
    };
  };

}
