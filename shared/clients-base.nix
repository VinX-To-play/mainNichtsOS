{ pkgs, inputs, config,  ... }: {
########################################################
#                       Packages                       #
######################################################## 
environment.systemPackages = with pkgs; [
    # Tools
    figlet
    bitwarden-desktop

    #Media
    jellyfin-ffmpeg
    deluge
    mpv
    psst
    spotify-player

    #Web
    inputs.zen-browser.packages."${system}".specific
    psst
    stable.vesktop

    #Office
    libreoffice-qt
    obsidian
    thunderbird
    koreader
 
    # Programing
    jetbrains.idea-ultimate
    vscode-fhs
    gradle
    dia
    simulide_1_2_0

    # Programing lange
    # rust dependency installd throu nixvim
    python3
    gcc

    # Gaming
    heroic

    # Wayland & Display:
    wlroots_0_17
    egl-wayland
    xwayland

    # Own aplications
    (callPackage ./../Packages/Helium/package.nix {} )

    ];

    programs.gamescope = {
      enable = true;
      capSysNice = true;
  };

    #install Steam
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          OBS_VKCAPTURE = true;
        };
        extraLibraries = p: with p; [
          usbutils
        ];
      };
      gamescopeSession.enable = true;
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  users.users.vincentl.extraGroups = [ "wireshark" ];


########################################################
#		     Imports			       #
########################################################
  imports = [
    ./modules/fonts.nix
  ];

########################################################
#                 Hardware & Driver                    #
######################################################## 
  
  # Enable CUPS to print documents.
  services.printing.enable = true;

  #enable Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Pen inputs
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;

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
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.firewall.trustedInterfaces = [ "p2p-wl+" ];
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
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

  #force electron to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
