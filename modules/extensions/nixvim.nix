{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.nixvim;
in {
  options.vinlabs.nixvim.enable = mkEnableOption "Nixvim (Neovim) editor";

  config = mkIf cfg.enable {
    home-manager.users.vincentl.imports = [
      ../../nixosModules/nixvim/nixvim.nix
    ];
  };
}
