{ pkgs, lib, ... }:
let
  mod = "Mod4";
in {
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx-unwrapped;
    checkConfig = false;
    extraConfig = ''
    for_window [all] titlebar hide

    include ~/.config/sway/outputs
    '';
    config = {
      modifier = mod;
      keybindings = lib.attrsets.mergeAttrsList [
        (lib.attrsets.mergeAttrsList (map (num: let
          ws = toString num;
        in {
          "${mod}+${ws}" = "workspace ${ws}";
          "${mod}+Shift+${ws}" = "move container to workspace ${ws}";
        }) [1 2 3 4 5 6 7 8 9]))

        (lib.attrsets.concatMapAttrs (key: direction: {
            "${mod}+${key}" = "focus ${direction}";
            "${mod}+Shift+${key}" = "move ${direction}";
          }) {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
            Left = "left";
            Down = "down";
            Up = "up";
            Right = "right";
          })

        {
          # Workspace 10
          "${mod}+0" = "workspace 10";
          "${mod}+Shift+0" = "move container to workspace 10";

          # Applications
          "${mod}+t" = "exec --no-startup-id ${pkgs.kitty}/bin/kitty";
          "${mod}+s" = "exec --no-startup-id rofi -show drun run window";
          "${mod}+b" = "exec --no-startup-id zen";
          "${mod}+Shift+b" = "exec --no-startup-id Helium";
          "${mod}+e" = "exec --no-startup-id nemo";

          # Window managment
          "${mod}+q" = "kill";
          "${mod}+Shift+a" = "focus parent";
          "${mod}+Shift+e" = "layout toggle split";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+Shift+g" = "split h";
          # "${mod}+Shift+s" = "layout stacking";
          "${mod}+Shift+v" = "split v";
          "${mod}+Shift+w" = "layout tabbed";

          "${mod}+Shift+r" = "exec swaymsg reload";
          "${mod}+Ctrl+q" = "exit";

          #Screenshot
          "${mod}+Shift+s" = "exec --no-startup-id hyprshot -m region --clipbord-only";
          "${mod}+Print" = "exec --no-startup-id hyprshot -m window";
          "Print" = "exec --no-startup-id hyprshot -m output";
          "${mod}+Shift+Print" = "exec --no-startup-id hyprshot -m region";
          "${mod}+Shift+t" = "exec --no-startup-id sh -c 'hyprshot -m region --raw | tesseract - - | wl-copy'";

          # Audio & Monitor
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
        {command = "zen";}
        {command = "waybar";}
        {command = "mako";}
        {command = "blueman-applet";}
        {command = "wl-paste --watch cliphist store";}
        {command = "eww daemon";}

      ];
      workspaceAutoBackAndForth = true;
      # disable the bar
      bars = []; 
      window.titlebar = false;
      
    };
    systemd.enable = true;
    wrapperFeatures = {gtk = true;};
  };
}
