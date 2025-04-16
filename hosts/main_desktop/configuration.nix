# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../shared/base.nix
      ../../shared/modules/obs.nix
      ../../shared/modules/style.nix
      ../../shared/modules/art.nix
      ../../shared/modules/sunshine.nix
      ../../shared/modules/vr.nix
      ../../shared/modules/hyprland/hyprland.nix
      
    ];
  
  ##########################################
  #            Boot                        #
  ##########################################
  #boot.loader.grub.devices =  ["dev/nvme0n1p1"];
  boot.kernelPackages = pkgs.linuxPackages_latest; 

  networking.hostName = "nichtsos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.interfaces.enp3s0.wakeOnLan.enable = true;
  networking.interfaces.enp3s0.macAddress = "d6:22:c7:46:18:b4";  


  
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
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
   ];
  };
 
  # for huion 13
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;

  # set .config backup extansion for home manager
  home-manager.backupFileExtension = "backup4";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    piper
    libratbag
    ldmtool
  ];

  #mouse configeration
  services.ratbagd = {
      enable = true;
  };
  
 hardware.graphics = {
	    enable = true;
	    enable32Bit = true;
	  };
	 services.xserver.videoDrivers = [ "nvidia" ];
	 hardware.nvidia = {
	      # Modesetting is required.
	      modesetting.enable = true;
	      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
	      powerManagement.enable = false;
	      # Fine-grained power management. Turns off GPU when not in use.
	      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
	      powerManagement.finegrained = false;
	      # Use the NVidia open source kernel module (not to be confused with the
	      # independent third-party "nouveau" open source driver).
	      # Support is limited to the Turing and later architectures. Full list of
	      # supported GPUs is at:
	      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
	      # Only available from driver 515.43.04+
	      # Currently alpha-quality/buggy, so false is currently the recommended setting.
	      open = false;
	      # Enable the Nvidia settings menu,
	      # accessible via `nvidia-settings`.
	      nvidiaSettings = true;
	      # Optionally, you may need to select the appropriate driver version for your specific GPU.
	      package = config.boot.kernelPackages.nvidiaPackages.beta;
	    };
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" ];

  #fix for explicit sync problems on webkit2gtk
  environment.variables = { WEBKIT_DISABLE_DMABUF_RENDERER = "1"; };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
