{ config, ... }:
{
  flake.modules.nixos.nixosConfigurations.nichtsos-T14 = {
    imports = with config.flake.modules.nixos; [
      pc
    ];
    system.stateVersion = "23.11";
  };
}
