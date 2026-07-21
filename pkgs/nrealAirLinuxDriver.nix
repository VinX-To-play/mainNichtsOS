{
 hidapi,
 json_c,
 libusb1,
 opencv,
 systemd,
 stdenv,
 cmake,
 pkg-config,
 fetchFromGitLab,
 ...
}:
stdenv.mkDerivation {
  name = "nrealAirLinuxDriver";
  version = "unstable";

  src = fetchFromGitLab {
    owner = "TheJackiMonster";
    repo = "nrealAirLinuxDriver";
    rev = "9a1f55c9838cf92627cde62f9bd69269d213d134"; # 2025-07-15
    fetchSubmodules = true;
    hash = "sha256-XV5X6+VlXSNc60dnXeq736RqY6140Q/zKr9VV0o9awk=";
  };
  
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hidapi
    json_c
    libusb1
    opencv
    systemd
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp xrealAirLinuxDriver $out/xrealAirLinuxDriver

    mkdir -p $out/lib
    find interface_lib -name "*.so*" -exec install -m755 {} $out/lib/ \;

    mkdir -p $out/etc/udev/rules.d
    cp ../udev/nreal_air.rules $out/etc/udev/rules.d/

    rm -rf ../build/

    runHook postInstall
  '';
}

