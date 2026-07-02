{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "nichtsos";
  boot.kernelParams = [ "drm.edid_firmware=DP-1:edid/my-edid.bin" "video=DP-1:2560x1440@144e" ];

  # TODO move to openssh module
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      UseDns = true;
      PasswordAuthentication = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
      AllowAgentForwarding = "yes";
    };
  };

  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "192.168.1.201" "1.1.1.1" ];

  networking.interfaces.enp7s0 = {
    wakeOnLan = {
      enable = true;
      policy = [ "magic" ];
    };
    ipv4.addresses = [{
      address = "192.168.1.2";
      prefixLength = 24;
    }];
  };

  services.ratbagd.enable = true;

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
  home-manager.backupFileExtension = "backup109";

  system.stateVersion = "23.11";

  vinlabs = {
    desktop.enable = true;
    gaming.enable = true;
    workstation.enable = true;
    hyprland.enable = true;
    sway.enable = true;
    obs.enable = true;
    sunshine.enable = true;
    vr.enable = true;
    gns3.enable = true;
    llama-cpp.enable = true;
    # TODO maybe move fonts to desktop or import througe sway/hyprland
    fonts.enable = true;
    art.enable = true;
  };
}
