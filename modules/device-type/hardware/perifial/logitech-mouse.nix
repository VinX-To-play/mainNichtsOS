{...}:{
  flake.nixosModules.logitech-mouse = {pkgs, ...}:{
    environment.systemPackages = with pkgs;[
      piper
      libratbag
      stable.ldmtool
    ];

    services.ratbagd = {
      enable = true;
    };
  };
}
