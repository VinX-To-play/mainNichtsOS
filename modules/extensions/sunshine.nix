{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.sunshine;
in {
  options.vinlabs.sunshine.enable = mkEnableOption "Sunshine remote desktop";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sunshine ];
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
