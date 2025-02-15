{ config, inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    alvr
  ];

  #ALVR for VR gaming
  programs.alvr = {
      enable = true;
      openFirewall = true;
  };

  # VR streaming alternetive for ALVR
  services.wivrn = {
  enable = false;
  openFirewall = true;
  };

}