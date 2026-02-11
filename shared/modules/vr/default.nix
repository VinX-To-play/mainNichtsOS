{...}: {
  imports = [
    ./vr.nix
    ./amdgpu/patch.nix
    ./utils.nix
    ./monado.nix
  ];
}
