# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../shared/base.nix
      ../../shared/clients-base.nix
      ../../shared/modules/obs.nix
      ../../shared/modules/style.nix
      ../../shared/modules/art.nix
      ../../shared/modules/sunshine.nix
      ../../shared/modules/sway/sway.nix
      ../../shared/modules/hyprland/hyprland.nix
      ../../shared/modules/vr/default.nix
      ../../shared/modules/gns3.nix
      ../../shared/modules/lama-cpp.nix
    ];
  
  ##########################################
  #            Boot                        #
  ##########################################
  #boot.loader.grub.devices =  ["dev/nvme0n1p1"];

  networking = {
    hostName = "nichtsos"; # Define your hostname.
    networkmanager.enable = true;
    nameservers = [
      "192.168.1.201"
      "1.1.1.1"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        8000
      ];
    };
    defaultGateway = "192.168.1.1";
    interfaces.enp7s0 = {
      wakeOnLan = {
        enable = true;
        policy = [ "magic" ];
      };
      
      ipv4.addresses = [{
	address = "192.168.1.2";
	prefixLength = 24;
      }];
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  home-manager.users.vincentl = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.bash.enable = true;
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vincentl = {
    isNormalUser = true;
    description = "Vincent Lundborg";
    extraGroups = [ 
      "networkmanager"
      "wheel"
      "dialout"
    ];
    packages = with pkgs; [
      #stable.torzu
   ];
  };
 
  # set .config backup extansion for home manager
  home-manager.backupFileExtension = "backup105";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    piper
    libratbag
    stable.ldmtool
  ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      UseDns = true;
      PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };


  #mouse configeration
  services.ratbagd = {
      enable = true;
  };
  

 hardware.graphics = {
	    enable = true;
	    enable32Bit = true;
	  extraPackages = with pkgs; [
	  ];
	  };
  
  hardware.amdgpu.opencl.enable = true;
  systemd.tmpfiles.rules = 
  let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ]; 



   # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
