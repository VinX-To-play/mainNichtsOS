{...}:{
  flake.nixosModules.base = {pkgs, ...}: {
    boot.kernelPackages = pkgs.linuxPackages_7_3;
  };
}
