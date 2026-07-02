{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.server;
in {
  options.vinlabs.server.enable = mkEnableOption "server";

  # TODO the grub thing is only for this server machine not the uscase server and should be moved to the nixosConfigurations same for the user and system.stateVersion

  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.loader.grub.enable = lib.mkForce true;
    boot.loader.grub.device = "/dev/sda/";
    boot.loader.grub.useOSProber = true;


    users.users.vincentl = {
      isNormalUser = true;
      description = "Vincent Lundborg";
      extraGroups = [ "networkmanager" "wheel" "smbUser" ];
    };

    services.openssh.enable = true;

    system.stateVersion = "25.05";
  };
}
