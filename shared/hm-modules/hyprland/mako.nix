{ pkgs, ... }:
{
  services.mako = {
    enable = true;
    package = pkgs.mako;
    settings = {
      actions = true;
      icons = true;
      markup = true;
      layer = "top";
      default-timeout = 5000;
      border-radius = 30;
    };
  };
}
