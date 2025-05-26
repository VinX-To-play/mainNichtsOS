{pkgs, lib, ...}:{ 
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "adwaita-icon-theme";
    };
  };

}
