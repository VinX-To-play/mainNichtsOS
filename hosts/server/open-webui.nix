{pkgs,config, ...}:
{
  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 11111;
  };

  services.nginx.virtualHosts."chat.slave.int" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
        proxyPass = "http://${config.services.open-webui.host}:${config.services.open-webui.port}";
    };
  };
}
