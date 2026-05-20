{ pkgs, lib, config, ...}:
{
  services.open-webui = {
    enable = true;
    port = 11111;
    host = "127.0.0.1";
    environment = {
      ENABLE_PERSISTENT_CONFIG = "False";
      ENABLE_OPENAI_API = "True";
      OPENAI_API_BASE_URL = "main.int:11343";
      WEBUI_AUTH = "False";
    };
  };

  services.nginx.virtualHosts."chat.slave.int" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
        proxyPass = "http://${config.services.open-webui.host}:${toString config.services.open-webui.port}";
    };
  };
}
