{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.fonts;
in {
  options.vinlabs.fonts.enable = mkEnableOption "extra fonts";

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [ arkpandora_ttf ];
  };
}
