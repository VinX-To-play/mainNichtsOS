{...}:{
  flake.modules.pc = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      auto-cpufreq
      ethtool
      powertop
      fastfetch
      btop
      tree
      stable.p7zip-rar
      sops
      busybox
      wget
      git
      tmux
      atool # TODO maybe remove
      httpie # TODO maybe remove
    ];

    # TODO maybe a power module
    services.auto-cpufreq = true;
    services.power-profiles-daemon.enable = true;
  };
}
