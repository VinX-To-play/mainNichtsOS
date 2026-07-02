{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vinlabs.sway;
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
in {
  options.vinlabs.sway.enable = mkEnableOption "Sway compositor";

  config = mkIf cfg.enable {
    # TODO needs to enable waybar, mako, rofy
    xdg.portal.wlr.enable = true;

    environment.systemPackages = with pkgs; [ rofi ];
    systemd.user.services.kanshi = {
      description = "kanshi daemon";
      environment = {
        WAYLAND_DISPLAY = "wayland-1";
        DISPLAY = ":0";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
      };
    };
    services.displayManager.sessionPackages = [ swaySession ];

    home-manager.users.vincentl = { pkgs, lib, ... }: let
      mod = "Mod4";
    in {
      wayland.windowManager.sway = {
        enable = true;
        package = pkgs.swayfx;
        checkConfig = false;
        systemd.enable = true;
        wrapperFeatures.gtk = true;
        extraConfig = ''
          include ~/.config/sway/outputs
          include ~/.config/sway/outputs
          corner_radius 20
          blur enable
          input "type:touchpad" { tap enable }
        '';
        config = {
          modifier = mod;
          keybindings = lib.attrsets.mergeAttrsList [
            (lib.attrsets.mergeAttrsList (map (num: let ws = toString num; in {
              "${mod}+${ws}" = "workspace ${ws}";
              "${mod}+Shift+${ws}" = "move container to workspace ${ws}";
            }) [ 1 2 3 4 5 6 7 8 9 ]))
            (lib.attrsets.concatMapAttrs (key: direction: {
              "${mod}+${key}" = "focus ${direction}";
              "${mod}+Shift+${key}" = "move ${direction}";
            }) { h = "left"; j = "down"; k = "up"; l = "right"; Left = "left"; Down = "down"; Up = "up"; Right = "right"; })
            {
              "${mod}+0" = "workspace 10";
              "${mod}+Shift+0" = "move container to workspace 10";
              "${mod}+t" = "exec --no-startup-id ${pkgs.kitty}/bin/kitty";
              "${mod}+s" = "exec --no-startup-id rofi -show drun run window";
              "${mod}+b" = "exec --no-startup-id zen";
              "${mod}+Shift+b" = "exec --no-startup-id Helium";
              "${mod}+e" = "exec --no-startup-id nemo";
              "${mod}+v" = "exec cliphist list | rofi -dmenu | cliphist decode | wl-copy";
              "${mod}+q" = "kill";
              "${mod}+Shift+a" = "focus parent";
              "${mod}+Shift+e" = "layout toggle split";
              "${mod}+f" = "fullscreen toggle";
              "${mod}+Shift+g" = "split h";
              "${mod}+Shift+v" = "split v";
              "${mod}+Shift+w" = "layout tabbed";
              "${mod}+Shift+r" = "exec swaymsg reload";
              "${mod}+Ctrl+q" = "exit";
              "${mod}+Shift+s" = "exec --no-startup-id hyprshot -m region --clipbord-only";
              "${mod}+Print" = "exec --no-startup-id hyprshot -m window";
              "Print" = "exec --no-startup-id hyprshot -m output";
              "${mod}+Shift+Print" = "exec --no-startup-id hyprshot -m region";
              "${mod}+Shift+t" = "exec --no-startup-id sh -c 'hyprshot -m region --raw | tesseract - - | wl-copy'";
              "Ctrl + v" = "exec wl-paste";
              "XF86AudioMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SINK@ toggle";
              "XF86AudioMicMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SOURCE@ toggle";
              "XF86AudioRaiseVolume" = "exec --no-startup-id wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
              "XF86AudioLowerVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
              "XF86AudioNext" = "exec --no-startup-id playerctl next";
              "XF86AudioPrev" = "exec --no-startup-id playerctl previous";
              "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
              "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set '1%+'";
              "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set '1%-'";
            }
          ];
          focus.followMouse = true;
          startup = [
            { command = "zen"; }
            { command = "waybar"; }
            { command = "mako"; }
            { command = "blueman-applet"; }
            { command = "wl-paste --watch cliphist store"; }
            { command = "eww daemon"; }
          ];
          workspaceAutoBackAndForth = true;
          bars = [];
          window.titlebar = false;
        };
      };
    };
  };
}
