{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.vinlabs.hyprland;
in {
  options.vinlabs.hyprland.enable = mkEnableOption "Hyprland compositor";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      brightnessctl
      gnome-calendar
      hyprpolkitagent
      networkmanagerapplet
      hyprlock
      hyprshot
      playerctl
      stable.nwg-displays
      cliphist
      wl-clipboard
      adwaita-qt
      adwaita-qt6
      pavucontrol
      libnotify
      rofi
      eww
      qimgv
      imagemagick
      tesseract
    ];

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    xdg.icons.enable = true;
    security.pam.services.hyprland.enableGnomeKeyring = true;

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    home-manager.users.vincentl = { pkgs, config, ... }: {
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        systemd.variables = [ "--all" ];
        settings = {
          general = {
            gaps_in = 0;
            gaps_out = 0;
          };
          source = [
            "/home/vincentl/.config/hypr/monitors.conf"
            "/home/vincentl/.config/hypr/workspaces.conf"
          ];
          input = {
            natural_scroll = false;
          };
          "$mod" = "SUPER";
          bind = [
            "ALT, Tap, cyclenext"
            "SHIFT, ALT, cyclenext, priv"
            "$mod, q, killactive"
            "$mod, F, fullscreen"
            "$mod shift, F, togglefloating"
            "$mod SHIFT, S, exec, hyprshot -m region --clipbord-only"
            "$mod, PRINT, exec, hyprshot -m window"
            ", PRINT, exec, hyprshot -m output"
            "$mod SHIFT, PRINT, exec, hyprshot -m region"
            "$mod SHIFT, T, exec, hyprshot -m region --raw | tesseract - - | wl-copy"
            "$mod,left,movefocus,l"
            "$mod,right,movefocus,r"
            "$mod,up,movefocus,u"
            "$mod,down,movefocus,d"
            "$mod,K,movefocus,u"
            "$mod,J,movefocus,d"
            "$mod,H,movefocus,l"
            "$mod,L,movefocus,r"
            "$mod,1,workspace,1"
            "$mod,2,workspace,2"
            "$mod,3,workspace,3"
            "$mod,4,workspace,4"
            "$mod,5,workspace,5"
            "$mod,6,workspace,6"
            "$mod,7,workspace,7"
            "$mod,8,workspace,8"
            "$mod,9,workspace,9"
            "$mod,0,workspace,10"
            "$modSHIFT,1,movetoworkspacesilent,1"
            "$modSHIFT,2,movetoworkspacesilent,2"
            "$modSHIFT,3,movetoworkspacesilent,3"
            "$modSHIFT,4,movetoworkspacesilent,4"
            "$modSHIFT,5,movetoworkspacesilent,5"
            "$modSHIFT,6,movetoworkspacesilent,6"
            "$modSHIFT,7,movetoworkspacesilent,7"
            "$modSHIFT,8,movetoworkspacesilent,8"
            "$modSHIFT,9,movetoworkspacesilent,9"
            "$modSHIFT,0,movetoworkspacesilent,10"
            "$mod, S, exec, rofi -show drun run window"
            "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
            "$mod SHIFT, l, exec, hyprlock"
            "$mod, B, exec, zen"
            "$modSHIFT, B, exec, Helium"
            "$mod, O, exec, obsidian"
            "$mod, T, exec, kitty"
            "$mod,E,exec, nemo"
          ];
          bindl = [
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
            ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86MonBrightnessUp, exec, brightnessctl set '1%+'"
            ", XF86MonBrightnessDown, exec, brightnessctl set '1%-'"
          ];
          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
            "$mod ALT, mouse:272, resizewindow"
          ];
        };
        extraConfig = ''
          exec-once = waybar
          exec-once = systemctl --user start hyprpolkitagent
          exec-once = mako
          exec-once = blueman-applet
          exec-once = wl-paste --watch cliphist store
          exec-once = ../../scripts/check-battery.sh
          exec-once = eww daemon
          layerrule = blur, namespace:blur
        '';
      };

      # TODO move to own module that gets impoted by hyprland / sway
      services.hypridle = {
        enable = true;
        package = pkgs.hypridle;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };
          listener = [
            {
              timeout = 900;
              on-timeout = "hyprlock";
            }
            {
              timeout = 1200;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

      # TODO move to own module that gets impoted by hyprland / sway
      services.mako = {
        enable = true;
        package = pkgs.mako;
        settings = {
          actions = true;
          icons = true;
          markup = true;
          layer = "top";
          default-timeout = 5000;
          border-radius = 30;
        };
      };

      programs.rofi = {
        enable = true;
        package = pkgs.rofi;
        cycle = true;
        plugins = with pkgs; [ rofi-power-menu rofi-calc ];
        theme = lib.mkForce "DarkBlue";
      };

      # TODO make waybar its on module since sway and hyprland uses it
      programs.waybar = {
        enable = true;
        package = pkgs.waybar;
        settings = [
          {
            layer = "top";
            position = "top";
            spacing = 5;
            modules-left = [ "hyprland/workspaces" "sway/workspaces" ];
            modules-center = [ "hyprland/window" "sway/window" ];
            modules-right = [ "cpu" "custom/div" "network" "custom/div" "pulseaudio" "backlight" "battery" "custom/div" "tray" "custom/div" "clock" "custom/div" "custom/powerwidgit" ];
            "hyprland/workspaces" = {
              format = "{name}";
              format-icons = { default = " "; active = " "; urgent = " "; };
              on-scroll-up = "hyprctl dispatch workspace e+1";
              on-scroll-down = "hyprctl dispatch workspace e-1";
            };
            "sway/workspaces" = {
              format = "{index}";
              format-icons = { default = " "; active = " "; urgent = " "; };
              on-scroll-up = "swaymsg workspace next";
              on-scroll-down = "swaymsg workspace prev";
            };
            "pulseaudio" = {
              format = "{icon} {volume}% {format_source}";
              format-bluetooth = "{icon} {volume}% {format_source}";
              format-bluetooth-muted = "{icon} 󰝟 {format_source}";
              format-muted = " 󰝟 {format_source}";
              format-source = " {volume}%";
              format-source-muted = "";
              format-icons = { headphone = ""; hands-free = ""; headset = ""; phone = ""; portable = ""; car = ""; default = [ "" "" "" ]; };
              on-click = "pavucontrol";
            };
            "hyprland/window" = { max-length = 22; separate-outputs = false; rewrite = { "" = " No Window? "; }; };
            "sway/window" = { format = "{title}"; max-length = 10; "all-outputs" = true; separate-outputs = false; rewrite = { "" = " No Window? "; }; };
            "clock" = { format = "{:%H:%M | %A %e %b}"; tooltip = true; tooltip-format = "<big>{:%A, %d.}</big>\n<tt><big>{calendar}</big></tt>"; on-click = "gnome-calendar"; };
            "tray" = { spacing = 3; };
            "custom/powerwidgit" = { format = "⏻  "; on-click = "/home/vincentl/.config/eww/powerwidgit.sh"; tooltip = false; };
            "custom/div" = { format = " | "; tooltip = false; };
            "network" = {
              format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
              format-ethernet = " {bandwidthDownOctets}";
              format-wifi = "{icon} {signalStrength}%";
              format-disconnected = "󰤮";
              tooltip = false;
              on-click = "kitty nmtui";
            };
            "battery" = { interval = 60; states = { warning = 30; critical = 15; }; format = "| {capacity}% {icon}"; format-icons = [ "" "" "" "" "" ]; max-length = 25; };
            "cpu" = { format = "{usage}% "; tooltip = false; on-click = "kitty btop"; };
            "backlight" = { format = "| {percent}% {icon}"; format-icons = [ "" "" "" "" "" "" "" "" "" ]; tooltip = false; };
          }
        ];
        style = ''
          @define-color bg-color rgb(68, 71, 90);
          @define-color bg-color-tray rgb (40, 42, 54);
          @define-color bg-color-ws rgb (40, 42, 54);
          @define-color bg-color-0 rgb (40, 42, 54);
          @define-color bg-color-1 rgb(40, 42, 54);
          @define-color bg-color-2 rgb(40, 42, 54);
          @define-color bg-color-3 rgb(40, 42, 54);
          @define-color bg-color-4 rgb(40, 42, 54);
          @define-color bg-color-5 rgb(40, 42, 54);
          @define-color bg-color-6 rgb(40, 42, 54);
          @define-color bg-color-7 rgb(40, 42, 54);
          @define-color bg-color-8 rgb(40, 42, 54);
          @define-color bg-color-9 rgb(40, 42, 54);
          @define-color bg-color-10 rgb(40, 42, 54);
          @define-color bg-color-11 rgb(40, 42, 54);
          @define-color bg-color-12 rgb(40, 42, 54);
          @define-color bg-color-13 rgb(40, 42, 54);
          @define-color bg-color-14 rgb(40, 42, 54);
          @define-color bg-color-15 rgb(40, 42, 54);
          @define-color bg-color-16 rgb(40, 42, 54);
          @define-color fg-color rgb (248, 248, 242);
          @define-color alert-bg-color rgb (255, 85, 85);
          @define-color alert-fg-color rgb (248, 248, 242);
          @define-color inactive-fg-color rgb(144, 153, 162);
          @define-color inactive-bg-color rgb(68, 71, 90);
          * { border: none; border-radius: 0; font-family: Dejavu Sans Mono, FontAwesome, Material Icons, sans-serif; font-size: 16px; min-height: 0; opacity: 1.0; }
          window#waybar { border-bottom: none; color: @fg-color; transition-property: background-color; transition-duration: .5s; }
          window#waybar.hidden { opacity: 0.4; }
          #clock { padding: 0 10px; margin: 0 0px; background-color: rgba(0,0,0,0); color: @fg-color; }
        '';
      };
    };
  };
}
