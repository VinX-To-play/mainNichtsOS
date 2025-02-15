{ config, inputs, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
      krita
      pureref
      unityhub
      alcom
    ];
}