{pkgs, ...}:{ 
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.sweet;
      name = "Sweet";
    };
  };

  home.packages = with pkgs; [
    sweet-folders
  ];

  qt = {
    enable = true;
  };
}
