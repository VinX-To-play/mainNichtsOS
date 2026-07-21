{...}: {
  perSystem = { pkgs, ...}: {
    packages = {
      helium = pkgs.callPackage ./helium/package.nix {};
      nrealAirLinuxDriver = pkgs.callPackage ./nrealAirLinuxDriver.nix {};
      Fusion = pkgs.callPackage ./Fusion.nix {};
    };
  };
  flake.overlays.additions = final: _prev: {
    helium = final.callPackage ./helium/package.nix {};
    nrealAirLinuxDriver = final.callPackage ./nrealAirLinuxDriver.nix {};
  };
}
