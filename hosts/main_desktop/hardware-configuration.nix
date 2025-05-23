# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "uhci_hcd" "ehci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b6569c20-92f5-4c83-9fca-525ad26a6097";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A2B8-CA1F";
      fsType = "vfat";
    };

    fileSystems."/mnt/500Gb" =
    { device = "/dev/disk/by-uuid/779ceceb-e50b-4651-962d-3c5765e1b4f2";
      fsType = "ext4";
    };

   fileSystems."/mnt/TB2" =
    { device = "/dev/disk/by-uuid/2537896a-0298-4a70-b219-50567560c249";
      fsType = "ext4";
    };

    fileSystems."/mnt/TB1" =
    { device = "/dev/disk/by-uuid/E010202C10200C5A";
      fsType = "ntfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d247d25c-0414-4905-93bd-71a835a04433"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
