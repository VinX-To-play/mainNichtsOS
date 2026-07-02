{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.ollama;
in {
  options.vinlabs.ollama.enable = mkEnableOption "Ollama AI server";

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      acceleration = if config.services.xserver.videoDrivers == [ "amdgpu" ] then "rocm"
                     else if config.services.xserver.videoDrivers == [ "nvidia" ] then "cuda"
                     else null;
      host = "[::]";
      openFirewall = true;
      environmentVariables = { OLLAMA_MAX_CTX_SIZE = "18192"; };
    };
    nixpkgs.config = {
      rocmSupport = config.services.xserver.videoDrivers == [ "amdgpu" ];
      cudaSupport = config.services.xserver.videoDrivers == [ "nvidia" ];
    };
  };
}
