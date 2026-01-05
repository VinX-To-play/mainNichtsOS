{
lib,
unzip,
autoPatchelfHook,
stdenv,
fetchurl,
xorg,
libgbm,
cairo,
libudev-zero,
libxkbcommon,
nspr,
nss,
libcupsfilters,
pango,
qt5,
alsa-lib,
atk,
at-spi2-core,
at-spi2-atk,
 }:

stdenv.mkDerivation rec {
    name = "Helium";
    version = "0.7.9.1";

    src = fetchurl {
	url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
        sha256 = "sha256-RL0MMsYmcboZt7aq2R/6onLX1bTxlEbhlwB7yBb84os=";
    };

    nativeBuildInputs = [ 
        unzip
        autoPatchelfHook
    ];

    autoPatchelfIgnoreMissingDeps = [
        "libQt6Core.so.6"
        "libQt6Gui.so.6"
        "libQt6Widgets.so.6"
    ];
    
    runtimeDependencies = [  ];
    buildInputs = [
        unzip
        xorg.libxcb
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        libgbm
        cairo
        pango
        libudev-zero
        libxkbcommon
        nspr
        nss
        libcupsfilters
        alsa-lib
        atk
        at-spi2-core
        at-spi2-atk
        qt5.qtbase
        qt5.qttools
        qt5.qtx11extras
        qt5.wrapQtAppsHook
    ];

    installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        mv * $out/bin/
        mv $out/bin/chrome $out/bin/${name}
        mkdir -p $out/share/applications
        
        cat <<INI> $out/share/applications/${name}.desktop
[Desktop Entry]
Name=${name}
GenericName=Web Browser
Terminal=false
Icon=$out/bin/product_logo_256.png
Exec=$out/bin/${name}
Type=Application
Categories=Network;WebBrowser;
INI
        '';


    meta = with lib; {
        homepage = "https://github.com/imputnet/helium-linux";
        description = "A description of your application";
        platforms = platforms.linux;
    };
}
