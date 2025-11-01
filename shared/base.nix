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

    # Programing
    wget
    git
    tmux
  ];

########################################################
#                   boot setings                       #
########################################################
boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.configurationLimit=10;
};

  boot.kernelPackages = pkgs.linuxPackages_zen; 



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


###################################################
#		      Secrets			  #
###################################################
programs.gnupg.agent = {
  enable = true;
  enableSSHSupport = true;
  };
security.polkit.enable = true;
}
