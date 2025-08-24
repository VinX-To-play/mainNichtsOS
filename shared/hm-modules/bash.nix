{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      exec fastfetch
      set -o vi
    '';
  };
}
