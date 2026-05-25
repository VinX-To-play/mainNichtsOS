{ pkgs, lib, config, ...}:
{
  services.open-webui = {
    enable = true;
    port = 11111;
    host = "127.0.0.1";
    environment = {
      ENABLE_PERSISTENT_CONFIG = "False";
      ENABLE_OPENAI_API = "True";
      OPENAI_API_BASE_URL = "http://main.int:11343/v1";
      WEBUI_AUTH = "False";
      CORS_ALLOW_ORIGIN = "https://chat.slave.int";
      WEBHOOK_URL = "chat.slave.int";
      REQUESTS_CA_BUNDLE = "/etc/ssl/certs/ca-bundle.crt";
      SEARXNG_URL = "https://search.slave.int/search?q=<query>";
      SEARXNG_API_KEY = "";
    };
  };

  services.nginx.virtualHosts."chat.slave.int" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
        proxyPass = "http://${config.services.open-webui.host}:${toString config.services.open-webui.port}";
        proxyWebsockets = true;
        extraConfig = "
          proxy_buffering off;
          proxy_cache off;
          proxy_read_timeout 1800;
          proxy_send_timeout 1800;
          proxy_connect_timeout 1800;
        ";
    };
  };
}
