
{...}: {
flake.nixosModules.amd = {pkgs, ...}: {
  boot.initrd.kernelModules = ["amdgpu"];
  hardware.graphics = {
	enable = true;
	enable32Bit = true;
	};
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.amdgpu.opencl.enable = true;
  systemd.tmpfiles.rules = 
  let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ]; 

	};
}
