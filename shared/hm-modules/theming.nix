{pkgs, lib, config, ...}:{ 
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "adwaita-icon-theme";
    };
  };
  gtk.gtk4.theme = config.gtk.theme;

}
