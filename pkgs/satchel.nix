{ lib
, stdenv
, fetchurl
, unzip
, autoPatchelfHook
, coreutils
, pkgs
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
, xorg
}:

stdenv.mkDerivation rec {
  pname = "satchel";
  version = "2.9.1";

  src = fetchurl {
    url = "https://github.com/virgilvox/satchel/releases/download/v${version}/satchel-linux-x86_64.zip";
    hash = "sha256-IGH+quP33tkLhcJ29hdatLz67pCsdKlBjW/9GHNkA0g=";
  };

  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
  ];

  buildInputs = [
    coreutils
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
    xorg.libX11
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
  ];

  sourceRoot = ".";

  postUnpack = ''
    chmod +x satchel-linux-x86_64
  '';

  installPhase = ''
    runHook preInstall

    # The real, patched binary lives here.
    install -Dm755 satchel-linux-x86_64 "$out/libexec/satchel/satchel-bin"

    install -Dm644 satchel.desktop \
      "$out/share/applications/satchel.desktop"
    install -Dm644 satchel.png \
      "$out/share/icons/hicolor/256x256/apps/satchel.png"

    # A wrapper that copies the binary into $XDG_DATA_HOME/satchel
    # if needed, then runs it from there. This gives SATCHEL a writable
    # directory to create its vault in.
    mkdir -p "$out/bin"
    cat > "$out/bin/satchel" <<EOF
#!${stdenv.shell}
set -euo pipefail

DATA_DIR="\''${XDG_DATA_HOME:-\$HOME/.local/share}/satchel"
STORE_BIN="${placeholder "out"}/libexec/satchel/satchel-bin"
USER_BIN="\$DATA_DIR/satchel-bin"

mkdir -p "\$DATA_DIR"

# Copy (or update) the binary into the writable data directory.
if ! "${coreutils}/bin/cmp" -s "\$STORE_BIN" "\$USER_BIN" 2>/dev/null; then
  "${coreutils}/bin/cp" "\$STORE_BIN" "\$USER_BIN"
  chmod +x "\$USER_BIN"
fi

# Make sure the patched libraries are visible.
export LD_LIBRARY_PATH="${lib.makeLibraryPath buildInputs}\''${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"

exec "\$USER_BIN" "\$@"
EOF
    chmod +x "$out/bin/satchel"

    runHook postInstall
  '';

  postFixup = ''
    autoPatchelf "$out/libexec/satchel/satchel-bin"
  '';

  meta = with lib; {
    description = "Portable RAG system with an embedded vault, web UI and MCP server";
    homepage = "https://github.com/virgilvox/satchel";
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "satchel";
    maintainers = with maintainers; [ ];
  };
}
