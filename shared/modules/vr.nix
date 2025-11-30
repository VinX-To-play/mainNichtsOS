{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # wivrn
    #  stable.alvr
      monado
      monado-vulkan-layers
      wlx-overlay-s
    ];


  services.monado = {
    enable = true;
    defaultRuntime = true; # Register as default OpenXR runtime
    forceDefaultRuntime = true;
  };

    systemd.user.services.monado.environment = {
	STEAMVR_LH_ENABLE = "1";
	XRT_COMPOSITOR_COMPUTE = "1";
	WMR_HANDTRACKING = "0";
    };
  hardware.graphics.extraPackages = with pkgs; [monado-vulkan-layers];
  
}
