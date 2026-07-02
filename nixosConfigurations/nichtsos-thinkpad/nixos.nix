{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "nichtsos-thinkpad";

  users.users.vincentl = {
    isNormalUser = true;
    description = "Vincent Lundborg";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
  };

  home-manager.users.vincentl = { pkgs, ... }: {
    home.stateVersion = "24.05";
    home.packages = with pkgs; [ atool httpie ];
    programs.bash.enable = true;
  };
  home-manager.backupFileExtension = "backup9";

  system.stateVersion = "23.11";

  vinlabs = {
    desktop.enable = true;
    laptop.enable = true;
    hyprland.enable = true;
    sway.enable = true;
    obs.enable = true;
    fonts.enable = true;
  };
}
