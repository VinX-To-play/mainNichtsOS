{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.laptop;
in {
  options.vinlabs.laptop.enable = mkEnableOption "laptop";

  config = mkIf cfg.enable {
    services.printing.enable = true;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;
    # TODO opentabletdriver shoud be in the art module 
    hardware.opentabletdriver.enable = true;
    hardware.opentabletdriver.daemon.enable = true;
    hardware.bluetooth.settings = {
      General.ControllerMode = "bredr";
    };

    # TODO shoud be a audio submodule
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    networking.networkmanager.enable = true;
    networking.networkmanager.dns = "none";
    networking.firewall.trustedInterfaces = [ "p2p-wl+" ];

    # TODO use the vinlabs tailscale option instad of redefining it
    services.tailscale.enable = true;
    services.tailscale.useRoutingFeatures = "client";

    # TODO xserver should be a part of a wayland modul with xwayland and wayland that gets imported by the sway module and hyprland module
    services.xserver.enable = true;

    # TODO not laptop specific (only relevent to thinkpads
    boot.initrd.availableKernelModules = [ "thinkpad_acpi" ];

    services.upower.enable = true;
  };
}
