{ lib
, stdenv
, fetchurl
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
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # ← replace
  };

  # The zip contains only pre-built artefacts; no compiler is needed.
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  # Typical runtime libraries for a desktop application.
  # Expand this list if `autoPatchelfHook` reports missing dependencies.
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

  # The archive expands to the binary, satchel.desktop and satchel.png.
  # `autoPatchelfHook` needs the binary to be executable first.
  unpackPhase = ''
    runHook preUnpack
    unzip -q "$src"
    chmod +x satchel-linux-x86_64
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    # 1. The executable
    install -Dm755 satchel-linux-x86_64 "$out/bin/satchel"

    # 2. The desktop entry
    install -Dm644 satchel.desktop \
      "$out/share/applications/satchel.desktop"

    # 3. The icon (hicolor theme, 256×256 as specified in the desktop file)
    install -Dm644 satchel.png \
      "$out/share/icons/hicolor/256x256/apps/satchel.png"

    runHook postInstall
  '';

  # Optional: wrap the binary so it can be launched from the desktop entry
  # without relying on the user's PATH. This also allows passing `--no-browser`
  # as a default if you prefer, but here we keep the upstream behaviour.
  postFixup = ''
    wrapProgram "$out/bin/satchel" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
  '';

  meta = with lib; {
    description = "Portable RAG system with an embedded vault, web UI and MCP server";
    longDescription = ''
      SATCHEL is a self-contained Retrieval-Augmented Generation (RAG) tool
      that bundles an embedding model, a local vault, a browser-based UI and
      an MCP server. It runs entirely offline and can be carried on a USB
      drive.
    '';
    homepage = "https://github.com/virgilvox/satchel";
    license = licenses.mit; # check the repository for the actual licence
    platforms = [ "x86_64-linux" ];
    mainProgram = "satchel";
    maintainers = with maintainers; [ ]; # add yourself if you wish
  };
}
