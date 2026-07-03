{ config, inputs, ... }:
{
  flake.nixosConfigurations.nichtsos-thinkpad-T14 = inputs.nixpkgs.lib.nixosSystem {

    modules = (with config.flake.modules.nixos; [
      pc
    ]) ++ [
      ./_hardware-configuration.nix
    ({...}: {
      system.stateVersion = "23.11";
      })
    ];

  };
}
