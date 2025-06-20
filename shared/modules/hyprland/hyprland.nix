{inputs, pkgs, ...}: 

{
  environment.systemPackages = with pkgs; [
    brightnessctl
    waybar
    gnome-calendar
    hyprpolkitagent
    networkmanagerapplet
    rofi-wayland
    hyprlock
    hyprshot
    playerctl
    nwg-displays
    cliphist
    wl-clipboard
    adwaita-qt
    adwaita-qt6
    pavucontrol
    libnotify
    ];

  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  
  xdg.icons.enable = true;

  security.pam.services.hyprland.enableGnomeKeyring = true;

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
}
