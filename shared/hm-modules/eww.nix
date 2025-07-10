{config, pkgs, ...}:
{
  home.packages = pkgs.eww;
  
  home.file.".config/eww" = {
    source = ./../../Wigits/eww;
    recursive = true;
  };
}
