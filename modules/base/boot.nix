{lib,config, ...}:
let
  boot = config.vinlabs.pc.boot;
in {
  options.vinlabs.pc.boot.system = lib.mkOption {
    type = lib.types.enum [
      "systemd-boot"
      "grub"
    ];
    default = "systemd-boot";
  };

  options.vinlabs.pc.boot.grub.device = lib.mkOption {
    type = lib.types.path;
    default = null;
  };

  flake.modules.nixos.pc =
    { lib, ...}: {
      config = lib.mkMerge [
        (lib.mkIf (boot.system == "systemd-boot") {
          boot.loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
          };
        })
        (lib.mkIf (boot.system == "grub") {
          boot.loader.grub = {
            enable = true;
            device = boot.grub.device;
            useOSProber = true;
          };
        })
      ];
    };
}
