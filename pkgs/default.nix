{...}: {
  perSystem = { pkgs, ...}: {
    packages = {
      helium = pkgs.callPackage ./helium/package.nix {};
    };
  };
  flake.overlays.legacy = final: _: {
    helium = final.callPackage ./helium/package.nix {};
  };
}
