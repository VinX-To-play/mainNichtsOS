{lib, ...}: {
  flake.nixosModules.base =
    {
      boot.loader = {
        systemd-boot.enable = lib.mkDefault true;
        efi.canTouchEfiVariables = lib.mkDefault true;
    };
  };
}
