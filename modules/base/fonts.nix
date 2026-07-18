{...}: {
  flake.nixosModules.base = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      arkpandora_ttf
    ];
  };
}
