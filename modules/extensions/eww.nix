{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.eww;
in {
  # TODO must be enabeld by by waybar for the powermenue
  options.vinlabs.eww.enable = mkEnableOption "EWW widgets";

  config = mkIf cfg.enable {
    home-manager.users.vincentl = { config, pkgs, ... }: {
      home.file."${config.xdg.configHome}/eww" = {
        source = ../../Wigits/eww;
        recursive = true;
      };
    };
  };
}
