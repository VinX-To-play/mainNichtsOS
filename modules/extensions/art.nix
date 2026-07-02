{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.art;
in {
  options.vinlabs.art.enable = mkEnableOption "art/design tools";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ krita pureref unityhub alcom ];
  };
}
