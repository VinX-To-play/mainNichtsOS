{...}: {
  flake.nixosModules.gaming = {pkgs,...}: {
    environment.systemPackages = with pkgs; [
      heroic
    ];
  };
}
