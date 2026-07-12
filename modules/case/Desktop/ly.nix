{...}: {
  flake.nixosModules.Desktop = {...}: {
    services.displayManager = {
      ly = {
        enable = true;
      };
    };
  };
}
