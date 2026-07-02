{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.gns3;
in {
  options.vinlabs.gns3.enable = mkEnableOption "GNS3 network simulator";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gns3-gui gns3-server dynamips vpcs ];
    security.wrappers.ubridge = {
      source = "${pkgs.ubridge}/bin/ubridge";
      capabilities = "cap_net_raw,cap_net_admin=eip";
      owner = "root";
      group = "users";
      permissions = "u+rwx,g+rx";
    };
  };
}
