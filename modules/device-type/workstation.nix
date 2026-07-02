{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.workstation;
in {
  options.vinlabs.workstation.enable = mkEnableOption "workstation";

  config = mkIf cfg.enable {
    # TODO should be in a wayland module
    programs.xwayland.enable = true;

    # TODO should be in a Displaymanager module that is imported by hyperland/sway module
    services.displayManager.ly.enable = true;

    boot.loader.grub.theme = pkgs.catppuccin-grub;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # TODO should be a AMDGPU module under vinlabs
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    hardware.amdgpu.opencl.enable = true;

    systemd.tmpfiles.rules = let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [ rocblas hipblas clr ];
      };
    in [ "L+    /opt/rocm   -    -    -     -    ${rocmEnv}" ];
  };
}
