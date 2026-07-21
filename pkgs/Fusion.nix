{
stdenv,
cmake,
lib,
fetchFromGitHub
}:
stdenv.mkDerivation {
  pname = "fusion";
  version = "1.3.2"; 
  src = fetchFromGitHub {
    owner = "xioTechnologies";
    repo = "Fusion";
    rev = "main"; 
    hash = "sha256-fsSSfxD/L/FEzeA/lud73utqY5SwB452eZidMJ9N6g8=";
  };

  nativeBuildInputs =  [ cmake ];

  meta = with lib; {
    description = "A sensor fusion library for Inertial Measurement Units (IMUs)";
    homepage = "https://github.com/xioTechnologies/Fusion";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
