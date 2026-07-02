{ config, lib, ... }: {
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--accept-dns=false" ];
    extraUpFlags = [ "--login-server=https://headscale.swahnlabs.com/" ];
    authKeyFile = config.sops.secrets."services/tailscale/autkey".path;
    useRoutingFeatures = lib.mkDefault "client";
  };
  sops.secrets."services/tailscale/autkey" = {};

  networking.hosts = {
    "100.64.0.11" = [
      "obsidian-livesync.slave.int"
      "chat.slave.int"
      "search.slave.int"
    ];

    # should not be in tailscale since local adress remap
    "192.168.1.2" = [ "main.int" ];
  };
}
