{pkgs, config, lib, ...}:
let
  llama-swap-config = pkgs.writeText "llama-swap-config.yaml" ''
    globalTTL: 300
    healthCheckTimeout: 60
    includeAliasesInList: true
    
    models:
      deepseek-v4-flash:
        peer: deepseek
        model: deepseek-v4-flash
        TTL: 0
        filters:
          setParamsByID:
            "''${MODEL_ID}":
              thinking:
                type: "disabled"
            "''${MODEL_ID}:thinking":
              thinking:
                type: "enabled"
    
    peers:
      deepseek:
        proxy: "https://api.deepseek.com"
        apiKey: "''${env.DEEPSEEK_APIKEY}"
        models:
          - "deepseek-v4-flash"
    '';

in 
{
  services.llama-swap = {
    enable = true;
    port = 11343;
    listenAddress = "0.0.0.0";
    openFirewall = false;
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
