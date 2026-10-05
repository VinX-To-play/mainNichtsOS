{...}:{
flake.nixosModules.vr = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      bs-manager
      wayvr
    ];
  };
}
