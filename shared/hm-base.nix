{pkgs, config, ...}:
{
  imports = [
    ./hm-modules/kitty.nix
    ./hm-modules/kickstart.nixvim/nixvim.nix
    ./hm-modules/theming.nix
    ];

  home.packages = with pkgs; [
    nemo-with-extensions
    unzip
  ];

  # to auto activate nix develup
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.file."${config.xdg.configHome}" = {
    source = ../Wigits;
    recursive = true;
  };

}
