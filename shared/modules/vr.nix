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
    highPriority = true;
  };


    systemd.user.services.monado.environment = {
	XRT_COMPOSITOR_FORCE_WAYLAND_DIRECT= "1";
	STEAMVR_LH_ENABLE = "0";
	XRT_COMPOSITOR_COMPUTE = "1";
	WMR_HANDTRACKING = "0";
	"IPC_EXIT_ON_DISCONNECT" = "1";
    };
  hardware.graphics.extraPackages = with pkgs; [monado-vulkan-layers];
  
}
