{ pkgs, ... }:
{
  programs.mako = {
    enable = true;
    package = pkgs.mako;
    defaultTimeout = 5000;
    borderRadius = 30;
  };
}
