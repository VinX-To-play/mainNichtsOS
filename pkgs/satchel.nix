{ lib
, stdenv
, fetchurl
, unzip
, autoPatchelfHook
, coreutils
, util-linux
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
    hash = "sha256-IGH+quP33tkLhcJ29hdatLz67pCsdKlBjW/9GHNkA0g=";
  };

  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ unzip autoPatchelfHook ];

  buildInputs = [
    coreutils
    util-linux
    libGL libxkbcommon wayland libgbm libdrm
    alsa-lib cups dbus expat fontconfig freetype glib
    gtk3 nspr nss pango systemd
  ];

  sourceRoot = ".";

  postUnpack = ''
    chmod +x satchel-linux-x86_64
  '';

  installPhase = ''
    runHook preInstall

    # 1. Real binary → libexec (never $out/bin, so it can't be clobbered).
    install -Dm755 satchel-linux-x86_64 \
      "$out/libexec/satchel/satchel-bin"

    # 2. Desktop entry + icon.
    install -Dm644 satchel.desktop \
      "$out/share/applications/satchel.desktop"
    install -Dm644 satchel.png \
      "$out/share/icons/hicolor/256x256/apps/satchel.png"

    # 3. Wrapper → $out/bin/satchel.
    mkdir -p "$out/bin"
    cat > "$out/bin/satchel" <<EOF
#!${stdenv.shell}
set -euo pipefail

DATA_ROOT="\''${XDG_DATA_HOME:-\$HOME/.local/share}/satchel"
STORE_BIN="${placeholder "out"}/libexec/satchel/satchel-bin"
BUILD_TAG="${builtins.baseNameOf (placeholder "out")}"
VERSIONED_DIR="\$DATA_ROOT/versions/\$BUILD_TAG"
USER_BIN="\$VERSIONED_DIR/satchel-bin"
PERSISTENT_VAULT="\$DATA_ROOT/vault"

mkdir -p "\$VERSIONED_DIR" "\$PERSISTENT_VAULT"

# Serialise concurrent invocations.
exec 9>"\$DATA_ROOT/.satchel.lock"
${util-linux}/bin/flock 9

# Atomic update: build the new binary in a temp file with 0755, then
# rename over the old one. mv -f only needs directory write permission,
# so it works even if the previous satchel-bin ended up as 0555.
if ! ${coreutils}/bin/cmp -s "\$STORE_BIN" "\$USER_BIN" 2>/dev/null; then
  tmp="\$(${coreutils}/bin/mktemp "\$VERSIONED_DIR/.satchel-bin.XXXXXX")"
  ${coreutils}/bin/install -m 755 "\$STORE_BIN" "\$tmp"
  ${coreutils}/bin/mv -f "\$tmp" "\$USER_BIN"
fi

if [ ! -e "\$VERSIONED_DIR/vault" ]; then
  ${coreutils}/bin/ln -s "\$PERSISTENT_VAULT" "\$VERSIONED_DIR/vault"
fi

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
