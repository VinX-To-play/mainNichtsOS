{ self, inputs, ... }: {
  # Custom packages overlay
  flake.overlays.additions = final: _prev:
    import ../../pkgs { pkgs = final; };

  # Placeholder for package modifications
  flake.overlays.modifications = _final: _prev: { };

  # Stable packages as pkgs.stable.*
  flake.overlays.stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  # NixOS module that applies all overlays
  flake.nixosModules.base = { ... }: {
    nixpkgs.overlays = [
      self.overlays.additions
      self.overlays.modifications
      self.overlays.stable-packages
    ];
  };
}
