{ config, inputs, pkgs, ... }:

{
  environment.systemPackages = [pkgs.sunshine];

  #sunshine settings (remote Desktop)
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
  };
}