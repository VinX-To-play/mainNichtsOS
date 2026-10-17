{ self, ... }: {
flake.nixosModules.base = {config, lib, ...}: {
  imports = [ self.nixosModules.security ];

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
        "nix-server-one"
    ];
    "100.64.0.19" = [
        "nichtsos-thinkpad-14"
    ];
    "100.64.0.12" = [
        "nichtsos-main"
    ];
  };
};
}

