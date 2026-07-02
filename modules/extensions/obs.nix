{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.obs;
in {
  options.vinlabs.obs.enable = mkEnableOption "OBS Studio";

  config = mkIf cfg.enable {
    boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    boot.kernelModules = [ "v4l2loopback" ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      options v4l2loopback devices=2 video_nr=1,2 card_label="OBS Cam, Virt Cam" exclusive_caps=1
    '';
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [ wlrobs obs-pipewire-audio-capture waveform ];
    };
  };
}
