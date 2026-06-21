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
          "deepseek-v4-flash" = {
            proxy = "https://api.deepseek.com/";
            apiKey = '' ''${env.DEEPSEEK_APIKEY}'';
            TTL = 0;
            filters = {
              setParamsByID = {
                "\${MODEL_ID}" = {
                  thinking = {
                    type = "disabled";
                  };
                };

                "\${MODEL_ID}:thinking" = {
                  thinking = {
                    type = "enabled";
                  };
                };
              };
            };
          };
        };

        /*
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
        */
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
