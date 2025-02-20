{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      #wivrn
      stable.alvr
      #monado
      monado-vulkan-layers
      #wlx-overlay-s
    ];

  #ALVR for VR gaming
  programs.alvr = {
      enable = true;
      openFirewall = true;
  };
  
  /*
  # Envision
  programs.envision = {
    enable = true;
    openFirewall = true; # This is set true by default
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
*/
  hardware.graphics.extraPackages = with pkgs; [monado-vulkan-layers];

}
