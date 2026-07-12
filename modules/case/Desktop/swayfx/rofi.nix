{config, ...}: {

  flake.nixosModules.rofi = {...}: {
    home-manager.sharedModules = [ config.flake.homeModules.rofi ];
  };

  flake.homeModules.rofi = {pkgs, lib, ... }: {

    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      cycle = true;
      theme = lib.mkForce "DarkBlue";
    };
  };
}
