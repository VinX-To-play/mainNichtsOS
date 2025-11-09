{pkgs, config, ...}:
{
  imports = [
    ./hm-modules/kitty.nix
    ./hm-modules/kickstart.nixvim/nixvim.nix
    ./hm-modules/theming.nix
    ./hm-modules/bash.nix
    ];

  home.packages = with pkgs; [
    nemo-with-extensions
    unzip
  ];

  xdg.mimeApps = {
    enable = true;
      defaultApplications = {
    "x-scheme-handler/http" = [ "helium.desktop" ];
    "x-scheme-handler/https" = [ "helium.desktop" ];
    "text/html" = [ "helium.desktop" ];
    };
  };

  # to auto activate nix develup
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  
  programs.git = {
    enable=true;
    settings = {
      user = {
        email = "v@lundborgs.de";
        name = "VinX-To-play";
      };
    };
  };

  home.file."${config.xdg.configHome}" = {
    source = ../Wigits;
    recursive = true;
  };

}
