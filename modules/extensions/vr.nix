{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.vinlabs.vr;
in {
  options.vinlabs.vr.enable = mkEnableOption "VR support";

  config = mkIf cfg.enable {
    boot.kernelParams = [ "usbcore.autosuspend=-1" ];

    boot.extraModulePackages = [
      (pkgs.callPackage ../../nixosModules/amdgpu-derivation.nix {
        inherit (config.boot.kernelPackages) kernel;
        patches = [ inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone.patch ];
      })
    ];

    environment.systemPackages = with pkgs; [ bs-manager wayvr ];

    programs.steam = {
      package = lib.mkForce (pkgs.steam.override {
        extraProfile = ''
          unset TZ
          export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
          export PRESSURE_VESSEL_IMPORT_VULKAN_ICD=1
          export PRESSURE_VESSEL_IMPORT_VULKAN_LAYERS=1
        '';
      });
    };

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
                "target.object" = "alsa_output.usb-Alpha_Imaging_Tech_HTC_Vive-02.analog-stereo";
                "node.passive" = true;
              };
            };
          }
        ];
      };
    };

    services.monado = {
      enable = true;
      defaultRuntime = true;
      highPriority = true;
    };

    systemd.user.services."monado".environment = {
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
      XRT_DRIVER = "steamvr";
      U_PACING_COMP_TIME_FRACTION_PERCENT = "90";
    };

    users.users.vincentl.extraGroups = [ "video" "input" ];

    environment.sessionVariables.XR_RUNTIME_JSON = "${pkgs.monado}/share/openxr/1/openxr_monado.json";

    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="28de", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
      KERNEL=="hidraw*", ATTRS{idVendor}=="0bb4", MODE="0666"
      KERNEL=="hidraw*", ATTRS{idVendor}=="28de", MODE="0666"
    '';
  };
}
