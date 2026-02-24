{
   config,
    pkgs,
    osConfig,
    ...
  }: {
  xdg.configFile."openvr/openvrpaths.vrpath".text = let
    steam = "${config.xdg.dataHome}/Steam";
  in builtins.toJSON {
    version = 1;
    jsonid = "vrpathreg";
  
    external_drivers = null;
    config = [ "${steam}/config" ];
  
    log = [ "${steam}/logs" ];
  
    runtime = [
      #"${pkgs.xrizer}/lib/xrizer"
      # OR
      "${pkgs.opencomposite}/lib/opencomposite"
    ];
  };

  xdg.configFile."openxr/1/active_runtime.json".source =
    "${pkgs.monado}/share/openxr/1/openxr_monado.json";

  # home.sessionVariables = {
  #   XR_RUNTIME_JSON = "${config.home.homeDirectory}/.config/openxr/1/active_runtime.json";
  # };
}
