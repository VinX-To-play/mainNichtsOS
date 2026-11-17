{ lib
, stdenv
, fetchurl
, unzip                 # ← added
, autoPatchelfHook
, makeWrapper
, libGL
, libxkbcommon
, wayland
, libgbm
, libdrm
, alsa-lib
, cups
, dbus
, expat
, fontconfig
, freetype
, glib
, gtk3
, nspr
, nss
, pango
, systemd
}:

stdenv.mkDerivation rec {
  pname = "satchel";
  version = "2.9.1";

  src = fetchurl {
    url = "https://github.com/virgilvox/satchel/releases/download/v${version}/satchel-linux-x86_64.zip";
    hash = "sha256-IGH+quP33tkLhcJ29hdatLz67pCsdKlBjW/9GHNkA0g="; # ← replace
  };

  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [
    unzip               # ← needed for the default unpackPhase
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libGL
    libxkbcommon
    wayland
    libgbm
    libdrm
    alsa-lib
    cups
    dbus
    expat
    fontconfig
    freetype
    glib
    gtk3
    nspr
    nss
    pango
    systemd
  ];

  sourceRoot = ".";

  # Let stdenv's default unpackPhase extract the zip (it will call `unzip`,
  # which is now on PATH thanks to nativeBuildInputs). We only need to make
  # the shipped binary executable before autoPatchelfHook runs.
  postUnpack = ''
    chmod +x "$sourceRoot"/satchel-linux-x86_64
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 satchel-linux-x86_64 "$out/bin/satchel"
    install -Dm644 satchel.desktop \
      "$out/share/applications/satchel.desktop"
    install -Dm644 satchel.png \
      "$out/share/icons/hicolor/256x256/apps/satchel.png"

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/satchel" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
  '';

  meta = with lib; {
    description = "Portable RAG system with an embedded vault, web UI and MCP server";
    homepage = "https://github.com/virgilvox/satchel";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "satchel";
    maintainers = with maintainers; [ ];
  };
}
