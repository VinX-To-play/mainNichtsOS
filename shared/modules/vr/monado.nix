{ pkgs, ... }:
{
  services.monado = {
    enable = true;
    defaultRuntime = true;
  };

  systemd.services."monado".environment = {
    STEAMVR_LH_ENABLE = "true";
    XRT_COMPOSITOR_COMPUTE = "1";
  };

}
