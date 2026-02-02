{pkgs, ... }:
let
    swaySession = pkgs.stdenv.mkDerivation rec {
      pname = "sway-session";
      version = "1.0";

      dontUnpack = true;

      installPhase = ''
        mkdir -p $out/share/wayland-sessions
        cat > $out/share/wayland-sessions/sway-nvidia.desktop <<'EOF'
        [Desktop Entry]
        Name=Sway
        Exec=${pkgs.swayfx}/bin/sway 
        Type=Application
        X-GDM-Session-Type=Wayland
        EOF
      '';
      passthru.providedSessions = [ "sway-nvidia" ];
    };
in 
{
  
  xdg.portal.wlr.enable = true;

  environment.systemPackages = with pkgs; [
    rofi
  ];

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
  

  services.displayManager.sessionPackages = [ swaySession ];
}
