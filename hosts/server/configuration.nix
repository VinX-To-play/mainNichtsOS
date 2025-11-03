# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nginx.nix
      ../../shared/base.nix
      ../../shared/modules/style.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub.enable = lib.mkForce true;
  boot.loader.grub.device = "/dev/sda/";
  boot.loader.grub.useOSProber = true;

  networking = {
    hostName = "nix-server";
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    nameservers = ["1.1.1.1" "1.0.0.1"];
    interfaces = { 
      ens18.ipv4.addresses = [{
	address = "192.168.1.205";
	prefixLength = 24;
      }];
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
	22
      ];
    };
 };

  users.users.vincentl = {
    isNormalUser = true;
    description = "Vincent Lundborg";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager.users.vincentl = {pkgs, ... }: {
    home.packages = [pkgs.atool pkgs.httpie];
    programs.bash.enable = true;
    # do not change
   home.stateVersion = "25.05";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

