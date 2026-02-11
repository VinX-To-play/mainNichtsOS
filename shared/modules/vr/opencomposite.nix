{
   config,
    pkgs,
    osConfig,
    ...
  }: {
    xdg.configFile."openvr/openvrpaths.vrpath".text = ''
      {
        "config" :
        [
          "${config.xdg.dataHome}/Steam/config"
        ],
        "external_drivers" : null,
        "jsonid" : "vrpathreg",
        "log" :
        [
          "${config.xdg.dataHome}/Steam/logs"
        ],
        "runtime" :
        [
          "${pkgs.opencomposite}/lib/opencomposite",
          "${config.xdg.dataHome}/Steam/steamapps/common/SteamVR"
        ],
        "version" : 1
      }
    '';

  # should be in monado but this is in the homemanager context
   xdg.configFile."openxr/1/active_runtime.json".source = osConfig.environment.etc."xdg/openxr/1/active_runtime.json".source;
}
