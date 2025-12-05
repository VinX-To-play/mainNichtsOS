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
          })

        {
          
          "${mod}+t" = "exec --no-startup-id ${pkgs.kitty}/bin/kitty";
          "${mod}+s" = "exec --no-startup-id wofi --show drun,run";

          "${mod}+q" = "kill";

          "${mod}+a" = "focus parent";
          "${mod}+e" = "layout toggle split";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+g" = "split h";
          "${mod}+Shift+s" = "layout stacking";
          "${mod}+v" = "split v";
          "${mod}+w" = "layout tabbed";

          "${mod}+Shift+r" = "exec swaymsg reload";
          "--release Print" = "exec --no-startup-id ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          "${mod}+Ctrl+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";
          "${mod}+Ctrl+q" = "exit";
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
      
    };
    systemd.enable = true;
    wrapperFeatures = {gtk = true;};
  };
}
