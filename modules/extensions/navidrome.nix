{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.navidrome;
in {
  options.vinlabs.navidrome.enable = mkEnableOption "Navidrome music server";

  config = mkIf cfg.enable {
    services.navidrome = {
      enable = true;
      settings = {
        MusicFolder = "/srv/shared/music";
        Address = "127.0.0.1";
        Port = 8224;
        TLSCert = "";
        TLSKey = "";
      };
    };
    services.nginx.virtualHosts."navidrome.slave.int" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://${config.services.navidrome.settings.Address}:${toString config.services.navidrome.settings.Port}";
      locations."/".proxyWebsockets = true;
    };
  };
}
