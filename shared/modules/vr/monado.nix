{ pkgs, ... }:
{
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
    "IPC_EXIT_ON_DISCONNECT" = "1";
    # XRT_DEBUG_GUI = "1";
  };


  users.users.vincentl.extraGroups = ["video" "input"];

  environment.sessionVariables.XR_RUNTIME_JSON =
    "${pkgs.monado}/share/openxr/1/openxr_monado.json";

  # AI udev rouls for Vive
  services.udev.extraRules = ''
    # HTC Vive headset & linkbox and related HTC USB devices
    SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", MODE="0666"

    # Valve / Lighthouse / Watchman dongles
    SUBSYSTEM=="usb", ATTR{idVendor}=="28de", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"

    # hidraw access is usually the real blocker for VR devices on Linux
    KERNEL=="hidraw*", ATTRS{idVendor}=="0bb4", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="28de", MODE="0666"
  '';

}
