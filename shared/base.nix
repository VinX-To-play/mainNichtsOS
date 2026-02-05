{ config, inputs, pkgs, lib , ... }:

{
########################################################
#                       Packages                       #
######################################################## 
environment.systemPackages = with pkgs; [
    # Tools
    auto-cpufreq
    ethtool
    powertop
    fastfetch
    btop
    tree
    stable.p7zip-rar
    sops

    # Programing
    wget
    git
    tmux

  ];

  virtualisation.docker.enable = true;
########################################################
#                   boot setings                       #
########################################################
boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
};

  boot.kernelPackages = pkgs.linuxPackages;



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
	"libxml2-2.13.8"
      ];
      allowUnfree = true;
    };
  };

  # enable dirven for vscode intergraten withe shell.nix
  programs.direnv.enable = true;

########################################################
#                 Hardware & Driver                    #
######################################################## 
  
  #Power Saving by auto cpu frecuency
  services.auto-cpufreq.enable = true;
  services.power-profiles-daemon.enable = false;

#######################################################
#		    Networking			      #
#######################################################
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--accept-dns=false" ];
    extraUpFlags = [ "--login-server=https://headscale.swahnlabs.com/" ];
    authKeyFile = config.sops.secrets."services/tailscale/autkey".path;
    useRoutingFeatures =  lib.mkDefault "client";
  };
  
  sops.secrets."services/tailscale/autkey" = {};


###################################################
#		      Secrets			  #
###################################################
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    };
  security.polkit.enable = true;

  # add sops globaly
  system.extraDependencies = [pkgs.sops pkgs.age];
  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/vincentl/.config/sops/age/keys.txt";

}
