{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "nix-server";
  services.openssh.enable = true;

  users.users.vincentl = {
    isNormalUser = true;
    description = "Vincent Lundborg";
    extraGroups = [ "networkmanager" "wheel" "smbUser" ];
  };

  home-manager.users.vincentl = { pkgs, ... }: {
    home.stateVersion = "25.05";
    home.packages = with pkgs; [ atool httpie ];
    programs.bash.enable = true;
  };
  home-manager.backupFileExtension = "backup";

  system.stateVersion = "25.05";

  vinlabs = {
    server.enable = true;
    nginx.enable = true;
    vautwarden.enable = true;
    step-ca.enable = true;
    komga.enable = true;
    samba.enable = true;
    navidrome.enable = true;
    arr.enable = true;
    open-webui.enable = true;
    searxng.enable = true;
    llmswitch.enable = true;
    nix-cache.enable = true;
  };
}
