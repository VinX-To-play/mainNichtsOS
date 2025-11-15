{ pkgs, libs, ... }: {
programs.nixvim = {
  plugins.typst-preview = {
    enable = true;
    };
  plugins.typst-vim = {
    enable = true;
    };
  };
}
