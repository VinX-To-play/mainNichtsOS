{ pkgs, lib, config, ... }:

{
  environment.systemPackages = with pkgs; [
    # wivrn
    #  stable.alvr
      monado
      monado-vulkan-layers
      libsurvive
      wlx-overlay-s
      xrizer
    ];


  services.monado = {
    enable = true;
    defaultRuntime = true; # Register as default OpenXR runtime
    forceDefaultRuntime = true;
    highPriority = true;
  };

  programs.steam = {
    package = lib.mkForce ( pkgs.steam.override {
      extraProfile = ''
	# Fixes timezones on VRChat
      	unset TZ
      	# Allows Monado to be used
	#export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
      '';
    });
  };

  # home-manager.sharedModules = [
  #   ({pkgs, config, ...}: {
  #     xdg.configFile."openvr/openvrpaths.vrpath".text = let
  #       steam = "${config.xdg.dataHome}/Steam";
  #     in builtins.toJSON {
  #       version = 1;
  #       jsonid = "vrpathreg";

  #       external_drivers = null;
  #       config = [ "${steam}/config" ];
  #       
  #       log = [ "${steam}/logs" ];
  #       
  #       runtime = [
  #         "${pkgs.xrizer}/lib/xrizer"
  #       ];
  #     };
  #   })
  # ];


  systemd.user.services.monado.environment = {
    XRT_COMPOSITOR_FORCE_WAYLAND_DIRECT= "1";
    STEAMVR_LH_ENABLE = "0";
    XRT_COMPOSITOR_COMPUTE = "1";
    WMR_HANDTRACKING = "0";
    "IPC_EXIT_ON_DISCONNECT" = "1";
  };
  
  hardware.graphics.extraPackages = with pkgs; [monado-vulkan-layers];
  
}
