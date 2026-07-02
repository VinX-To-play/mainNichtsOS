{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ../../nixosModules/keybord-remap.nix ];
  networking.hostName = "nichtsos-thinkpad-T14";

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
  home-manager.backupFileExtension = "backup13";

  system.stateVersion = "23.11";

  vinlabs = {
    desktop.enable = true;
    laptop.enable = true;
    hyprland.enable = true;
    sway.enable = true;
    obs.enable = true;
    gns3.enable = true;
    fonts.enable = true;
    keyboard.enable = true;
  };
}
