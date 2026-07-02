{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.komga;
in {
  options.vinlabs.komga.enable = mkEnableOption "Komga comics/manga server";

  config = mkIf cfg.enable {
    services.komga = {
      enable = true;
      port = 9000;
      settings.server.port = 9000;
    };
    services.nginx.virtualHosts."komga.slave.int" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:9000";
    };
  };
}
