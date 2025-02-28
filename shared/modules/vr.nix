{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      wivrn
      stable.alvr
      monado
      monado-vulkan-layers
      #wlx-overlay-s
    ];

  #ALVR for VR gaming
  programs.alvr = {
      enable = true;
      openFirewall = true;
  };
  
  # VR streaming alternetive for ALVR
  services.wivrn = {
    enable = true;
    openFirewall = true;
    autoStart = true;
  };

  services.monado = {
    enable = true;
    defaultRuntime = true; # Register as default OpenXR runtime
  };

    systemd.user.services.monado.environment = {
	STEAMVR_LH_ENABLE = "1";
	XRT_COMPOSITOR_COMPUTE = "1";
	WMR_HANDTRACKING = "0";
    };
  hardware.graphics.extraPackages = with pkgs; [monado-vulkan-layers];
  
  # boot.kernelPatches = [pkgs.kernelPatches.cap_sys_nice_begone];
    
}
