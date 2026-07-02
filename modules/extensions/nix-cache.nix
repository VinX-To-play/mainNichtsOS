{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.nix-cache;
in {
  options.vinlabs.nix-cache.enable = mkEnableOption "Nix binary cache";

  config = mkIf cfg.enable {
    services.nix-serve = {
      enable = true;
      secretKeyFile = "/etc/nix/secret-key.pem";
    };
    services.nginx.virtualHosts."nix.slave.int" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
    };
  };
}
