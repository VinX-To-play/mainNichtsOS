{ pkgs, lib, ... }:
let
  mod = "Mod4";
in {
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    config = {
      modifier = mod;
      keybindings = lib.attrsets.mergeAttrsList [
        (lib.attrsets.mergeAttrsList (map (num: let
          ws = toString num;
        in {
          "${mod}+${ws}" = "workspace ${ws}";
          "${mod}+Ctrl+${ws}" = "move container to workspace ${ws}";
        }) [1 2 3 4 5 6 7 8 9 0]))

        (lib.attrsets.concatMapAttrs (key: direction: {
            "${mod}+${key}" = "focus ${direction}";
            "${mod}+Ctrl+${key}" = "move ${direction}";
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
          # Applications
          "${mod}+t" = "exec --no-startup-id ${pkgs.kitty}/bin/kitty";
          "${mod}+s" = "exec --no-startup-id rofi -show drun run window";
          "${mod}+b" = "exec --no-startup-id zen";
          "${mod}+Shift+b" = "exec --no-startup-id Helium";
          "${mod}+e" = "exec --no-startup-id nemo";

          # Window managment
          "${mod}+q" = "kill";

          
          # "${mod}+a" = "focus parent";
          # "${mod}+e" = "layout toggle split";
          # "${mod}+f" = "fullscreen toggle";
          # "${mod}+g" = "split h";
          # "${mod}+shift+s" = "layout stacking";
          # "${mod}+v" = "split v";
          # "${mod}+w" = "layout tabbed";

          "${mod}+Shift+r" = "exec swaymsg reload";
          "${mod}+Ctrl+q" = "exit";

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
      
    };
    systemd.enable = true;
    wrapperFeatures = {gtk = true;};
  };
}
