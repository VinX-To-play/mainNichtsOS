{ pkgs, lib, config, ... }:

{
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  programs.steam = {
    package = lib.mkForce ( pkgs.steam.override {
      extraProfile = ''
	# Fixes timezones on VRChat
      	unset TZ
      	# Allows Monado to be used
	export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
	export PRESSURE_VESSEL_IMPORT_VULKAN_ICD=1
  	export PRESSURE_VESSEL_IMPORT_VULKAN_LAYERS=1
      '';
      
    });
  };

  
}
