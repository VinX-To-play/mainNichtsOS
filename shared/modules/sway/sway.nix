{pkgs, ... }:
let
    swaySession = pkgs.stdenv.mkDerivation {
      pname = "sway-session";
      version = "1.0";
      nativeBuildInputs = [ pkgs.coreutils ];
      installPhase = ''
        mkdir -p $out/share/wayland-sessions
        install -m755 ${pkgs.swayfx}/bin/sway $out/bin/sway
        cat > $out/share/wayland-sessions/my-wayland-session.desktop <<EOF
        [Desktop Entry]
        Name=My Sway Session
        Exec=$out/bin/sway --unsupported-gpu
        Type=Application
        X-GDM-Session-Type=Wayland
        EOF
      '';
    };
in 
{
  # kanshi systemd service
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    environment = {
      WAYLAND_DISPLAY="wayland-1";
      DISPLAY = ":0";
    }; 
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };
  

  services.displayManager.sessionPackages = [ pkgs.swayfx ];
}
