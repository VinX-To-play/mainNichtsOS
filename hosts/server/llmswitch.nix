{pkgs, config, lib, ...}:
{
    services.llama-swap = {
      enable = true;
      port = 11343;
      listenAddress = "0.0.0.0";
      openFirewall = false;

      settings = 
      let
      in
      {
        globalTTL = 300;
        healthCheckTimeout = 60;
        models = {
          };
        peers = {
          deepseek = {
            proxy = "https://api.deepseek.com";
            apiKey = '' ''${env.DEEPSEEK_APIKEY}'';
            models = [
              "deepseek-v4-flash"
              "deepseek-v4-pro"
            ];
          };
        };
      };
    };

  systemd.services.llama-swap = {
    serviceConfig = {
      EnvironmentFile = config.sops.templates."llama-swap-server.env".path;
    };
  };

  sops.templates."llama-swap-server.env" = {
    content = ''
    DEEPSEEK_APIKEY=${config.sops.placeholder."llm-apiKey/deepseek"}
    '';
  };
  
  sops.secrets."llm-apiKey/deepseek" = {
  };

}
