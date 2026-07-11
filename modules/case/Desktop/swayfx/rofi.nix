{config, ...}: {

  flake.nixosModules.rofi = {
    home.sheardModules = [ config.flake.homeModules.rofi ];
  };

  flake.homeModules.rofi = {pkgs, ... }: {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      cycle = true;
      theme = "DarkBlue";
    };
  };
}
