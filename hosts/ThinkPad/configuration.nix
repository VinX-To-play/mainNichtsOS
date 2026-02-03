{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../shared/base.nix
      ../../shared/clients-base.nix
      ../../shared/modules/style.nix 
      ../../shared/modules/hyprland/hyprland.nix
      ../../shared/modules/sway/sway.nix
      ../../shared/modules/obs.nix
    ];

  boot.initrd.availableKernelModules = [
    "thinkpad_acpi"
  ];
  services.upower.enable = true;

  boot.extraModprobeConfig = ''
    options snd-hda-intel enable_msi=1
    '';


  networking.hostName = "nichtsos-thinkpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      11434
      3000
      # 22
      # 80
    ];
  };

  home-manager.users.vincentl = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.bash.enable = true;

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";
  };

  # set .config backup extansion for home manager
  home-manager.backupFileExtension = "backup9";

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vincentl = {
    isNormalUser = true;
    description = "Vincent Lundborg";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    packages = with pkgs; [ ];
  };

  environment.systemPackages = with pkgs; [
    maliit-keyboard
    maliit-framework
    jellyfin
    jellyfin-ffmpeg

  ];

    # INTEL DRIVERS
    hardware.graphics = {
        enable = true;
  	  enable32Bit = true; # driSupport32Bit in 24.05
        extraPackages = with pkgs; [
            intel-media-driver
            intel-vaapi-driver
            libva-vdpau-driver
            libvdpau-va-gl
            ];
        };

    nixpkgs.config.packageOverrides = pkgs: {
        vaapiIntel = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    };

  hardware.enableAllFirmware = true;

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
  # Or disable the firewall altogether  # networking.firewall.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
