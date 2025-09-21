{
 pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/25.05.tar.gz";
    sha256 = "sha256:1915r28xc4znrh2vf4rrjnxldw2imysz819gzhk9qlrkqanmfsxd";
 }) {}
 }:

pkgs.stdenv.mkDerivation rec {
    pname = "Helium";
    version = "0.4.7.1";

    src = pkgs.fetchurl {
	url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
        sha256 = "sha256:1a475cacdfdc900dbaa905a476f5ae82e9d62a30af735b92c456dbc3171b44b2";
    };

    nativeBuildInputs = with pkgs; [ 
        unzip
        autoPatchelfHook
    ];
    
    buildInputs = with pkgs; [
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
        libsForQt5.qtbase
        qt6.full
        libcupsfilters
        qt6.wrapQtAppsHook
    ];

    installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        mv * $out/bin/
        mkdir -p $out/share/applications
        
        cat <<INI> $out/share/applications/${pname}.desktop
        [Desktop Entry]
        Name=${pname}
        GenericName=Web Browser
        Terminal=false
        Icon=$out/bin/product_logo_256.png
        Exec=$out/bin/chrome
        Typ=Application
        Categories=Network;WebBrowser;
        '';


    meta = with pkgs.lib; {
        homepage = "https://github.com/imputnet/helium-linux";
        description = "A description of your application";
        platforms = platforms.linux;
    };
}
