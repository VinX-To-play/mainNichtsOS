{
  inputs,
  config,
  pkgs,
  ...
}: {
    boot.extraModulePackages = [
      (pkgs.callPackage ./_derivation.nix {
        inherit (config.boot.kernelPackages) kernel;
        patches = [
          inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone.patch
        ];
      })
    ];
}
