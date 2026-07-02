{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.step-ca;
in {
  options.vinlabs.step-ca.enable = mkEnableOption "Step CA certificate authority";

  config = mkIf cfg.enable {
    services.step-ca = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile /home/vincentl/Documents/mainNichtsOS/Dendritic/hosts/server/ca.json);
      address = "0.0.0.0";
      port = 8443;
      intermediatePasswordFile = "/var/lib/secrets/step-ca/intermediate_password";
    };
    networking.firewall.allowedTCPPorts = [ 8443 ];
  };
}
