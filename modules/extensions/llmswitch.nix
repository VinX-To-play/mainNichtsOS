{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.llmswitch;
in {
  options.vinlabs.llmswitch.enable = mkEnableOption "LLM switch proxy";

  config = mkIf cfg.enable {
    services.llama-swap = {
      enable = true;
      port = 11343;
      listenAddress = "0.0.0.0";
      openFirewall = false;
    };
    systemd.services.llama-swap.serviceConfig.EnvironmentFile = config.sops.templates."llama-swap-server.env".path;
    sops.templates."llama-swap-server.env" = {
      content = ''
        DEEPSEEK_APIKEY=${config.sops.placeholder."llm-apiKey/deepseek"}
      '';
    };
    sops.secrets."llm-apiKey/deepseek" = {};
  };
}
