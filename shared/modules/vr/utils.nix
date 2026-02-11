{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      bs-manager
      wayvr
    ];
}
