{ pkgs, ... }:
{
  services.monado = {
    enable = true;
    defaultRuntime = true;
    highPriority = true;
  };

  systemd.services."monado".environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
    XRT_FORCE_DRIVER = "steamvr";
  };

}
