{pkgs, ...}: {

programs.rofi = {
  enable = true;
  package = pkgs.rofi-wayland;
  cycle = true;
  plugins = [
    pkgs.rofi-power-menu
    pkgs.rofi-calc
  ];
  theme = "DarkBlue";
  };
}
