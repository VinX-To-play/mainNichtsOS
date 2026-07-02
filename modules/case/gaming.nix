{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.gaming;
in {
  options.vinlabs.gaming.enable = mkEnableOption "gaming";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ heroic ];
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          OBS_VKCAPTURE = true;
        };
        extraLibraries = p: with p; [ usbutils ];
      };
      gamescopeSession.enable = true;
    };
  };
}
