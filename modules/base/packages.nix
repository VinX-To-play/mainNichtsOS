{ pkgs, ... }: {
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
    goose-cli # TODO maybe remove?
  ];
  services.auto-cpufreq.enable = true;
  services.power-profiles-daemon.enable = false;
}
