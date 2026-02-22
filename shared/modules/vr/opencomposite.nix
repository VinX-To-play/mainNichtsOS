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
  
}
