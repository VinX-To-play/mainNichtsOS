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

  # reverse left & right audio on the HTC VIVE
  services.pipewire = {
    extraConfig.pipewire."99-vive-reverse" = {
      "context.modules" = [
        {
          name = "libpipewire-module-loopback";
          args = {
            "node.description" = "HTC Vive (Reverse Stereo)";
            "capture.props" = {
              "node.name" = "vive_reverse_input";
              "media.class" = "Audio/Sink";
              "audio.position" = [ "FL" "FR" ];
            };
            "playback.props" = {
              "node.name" = "vive_reverse_output";
              "audio.position" = [ "FR" "FL" ];
              # TARGET THE VIVE SPECIFICALLY HERE:
              "target.object" = "alsa_output.usb-Alpha_Imaging_Tech_HTC_Vive-02.analog-stereo";
              "node.passive" = true;
            };
          };
        }
      ];
    };
  };
  
}
