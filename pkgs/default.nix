{...}: {
  perSystem = { pkgs, ...}: {
    packages = {
      helium = pkgs.callPackage ./helium/package.nix {};
    };
  };
  flake.overlays.additions = final: _prev: {
    helium = final.callPackage ./helium/package.nix {};
  };
}
