{pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.gns3-gui
    pkgs.gns3-server
    pkgs.dynamips
    pkgs.vpcs
  ];

  security.wrappers.ubridge = {
    source = "${pkgs.ubridge}/bin/ubridge";
    capabilities = "cap_net_raw,cap_net_admin=eip";
    owner = "root";
    group = "users";
    permissions = "u+rwx,g+rx";
  };
}
