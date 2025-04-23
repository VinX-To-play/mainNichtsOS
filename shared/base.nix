{ config, inputs, pkgs, lib , ... }:

{
########################################################
#                   boot setings                       #
########################################################
boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.configurationLimit=10;
};

########################################################
#                  Display setings                     #
########################################################
# Enable the X11 windowing system.
  services.xserver.enable = true;

  #Enable wayland & autologin
  services.displayManager = { 
    sddm.enable = false;
    sddm.wayland.enable = false;
    ly.enable = true;
  };
  #enable plasma 6
  services.desktopManager.plasma6.enable = true;

  #force electron to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

########################################################
#                   Audio setings                      #
########################################################
  #sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

########################################################
#		Networking			       #
########################################################
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
  networking.firewall.allowedTCPPorts = [ 8010 7236 7250 ];  # for VLC Chromecast
    networking.firewall.trustedInterfaces = [ "p2p-wl+" ];

  networking.firewall.allowedUDPPorts = [ 7236 5353 ];

########################################################
#                  localiszation                       #
########################################################
  # Set your time zone.
	time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Configure console keymap
  console.keyMap = "us";

########################################################
#              Nix & Nixpkg Settings                   #
########################################################
  # alow for experimantel nix features
  nix = {
    settings = {  
      experimental-features = ["nix-command" "flakes" ];
      trusted-users = [ "root" "vincentl"];
    };
  };
  
  # List of Insecure Packages that are allowed 
  nixpkgs = {
    config = {
      permittedInsecurePackages = [
      ];
      allowUnfree = true;
    };
  };

  # enable dirven for vscode intergraten withe shell.nix
  programs.direnv.enable = true;

########################################################
#                 Hardware & Driver                    #
######################################################## 
  
  # Enable CUPS to print documents.
  services.printing.enable = true;

  #Power Saving by auto cpu frecuency
  services.auto-cpufreq.enable = true;
  services.power-profiles-daemon.enable = false;

  #enable Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

########################################################
#                       Packages                       #
######################################################## 
environment.systemPackages = with pkgs; [
    # Tools
    auto-cpufreq
    ethtool
    powertop
    wgnord
    fastfetch
    btop
    tree
    figlet

    #Media
    jellyfin-ffmpeg
    deluge
    vlc
    psst
    spotify-player

    #Web
    inputs.zen-browser.packages."${system}".specific
    psst
    whatsapp-for-linux
    vesktop

    #Office
    libreoffice-qt
    obsidian
    thunderbird
 
    # Programing
    wget
    git
    tmux
    vscode-fhs
    gradle
    dia
    zulu21

    # Programing lange
    rustc
    python3

    # Gaming
    heroic

    # Wayland & Display:
    wlroots_0_17
    egl-wayland
    xwayland

    ];

    #install Steam
    programs.steam.enable = true;

###################################################
#		      Secrets			  #
###################################################
programs.gnupg.agent = {
  enable = true;
  enableSSHSupport = true;
  };
security.polkit.enable = true;
}
