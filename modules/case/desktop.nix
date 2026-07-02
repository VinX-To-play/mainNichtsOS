{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.vinlabs.desktop;
  system = pkgs.stdenv.hostPlatform.system;
in {
  options.vinlabs.desktop.enable = mkEnableOption "desktop GUI apps";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      figlet
      ripgrep
      tldr
      deluge
      mpv
      psst
      spotify-player
      inputs.zen-browser.packages."${system}".specific
      vesktop
      discord
      obsidian
      thunderbird
      koreader
      jetbrains.idea
      vscode-fhs
      gradle
      dia
      simulide_1_2_0
      python3
      gcc
      (callPackage ../../pkgs/Helium/package.nix {})
    ];
  };
}
