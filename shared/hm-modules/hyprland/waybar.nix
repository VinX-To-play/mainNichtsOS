{
  pkgs,
  lib,
  host,
  config,
  ...
}:

with lib;
{
  # Configure & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "bottom";
        modules-left = [
	  "hyprland/workspaces" 
	];
        modules-center = [ 
	  "hyprland/window"
	];
        modules-right = [
	  "network"
	  "pulseaudio"
	  "tray"
	  "clock"
	];

        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        
	"hyprland/window" = {
          max-length = 22;
          separate-outputs = false;
          rewrite = {
            "" = " No Window? ";
          };
	};

	"clock" = {
	  format = "{:%H:%M %A%e %b}";
	  tooltip-format = "<big>{:%Y %B}</big>\n<tt><big>{calendar}</big></tt>";
	  today-format = "<b>{}</b>";
	  on-click = "gnome-calendar";
	};

	"tray" = {
	  spacing = 12;
	};

	"network" = {
          format-icons = [
	    "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = " {bandwidthDownOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };


      }
    ];
    style = concatStrings [
     ''

@define-color bg-color rgb(68, 71, 90);               /* #3C413C */
@define-color bg-color-tray rgb (40, 42, 54);         /* #3C4144 */
@define-color bg-color-ws rgb (40, 42, 54);         /* #3C4144 */
@define-color bg-color-0 rgb (40, 42, 54);            /* #3C4144 */
@define-color bg-color-1 rgb(40, 42, 54);            /* #475f94 */
@define-color bg-color-2 rgb(40, 42, 54);           /* #107AB0 */
@define-color bg-color-3 rgb(40, 42, 54);            /* #017374 */
@define-color bg-color-4 rgb(40, 42, 54);             /* #1F3B4D */
@define-color bg-color-5 rgb(40, 42, 54);           /* #10A674 */
@define-color bg-color-6 rgb(40, 42, 54);           /* #4984B8 */
@define-color bg-color-7 rgb(40, 42, 54);               /* #000133 */
@define-color bg-color-8 rgb(40, 42, 54);            /* #08787F */
@define-color bg-color-9 rgb(40, 42, 54);             /* #214761 */
@define-color bg-color-10 rgb(40, 42, 54);           /* #6C3461 */
@define-color bg-color-11 rgb(40, 42, 54);             /* #005249 */
@define-color bg-color-12 rgb(40, 42, 54);          /* #31668A */
@define-color bg-color-13 rgb(40, 42, 54);           /* #6A6E09 */
@define-color bg-color-14 rgb(40, 42, 54);          /* #5B7C99 */
@define-color bg-color-15 rgb(40, 42, 54);            /* #1D2021 */
@define-color bg-color-16 rgb(40, 42, 54);            /* #29293D  */

@define-color fg-color rgb (248, 248, 242);           /* #f3f4f5 */
@define-color alert-bg-color rgb (255, 85, 85);       /* #bd2c40 */
@define-color alert-fg-color rgb (248, 248, 242);       /* #FFFFFF */
@define-color inactive-fg-color rgb(144, 153, 162);   /* #9099a2 */
@define-color inactive-bg-color rgb(68, 71, 90);      /* #404552 */

* {
    border: none;
    border-radius: 0;
    font-family: Dejavu Sans Mono, FontAwesome, Material Icons, sans-serif;
    font-size: 16px;
    min-height: 0;
    opacity: 1.0;

}

window#waybar {
    background-color: rgba(40, 42, 54, 0);
    border-bottom: none;
    color: @fg-color;
    transition-property: background-color;
    transition-duration: .5s;
}

window#waybar.hidden {
    opacity: 0.4;
}


#workspaces button {
    padding: 0 5px;
    background-color: transparent;
    color: @fg-color;
    border-bottom: 3px solid transparent;
}

/* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
#workspaces button:hover {
    background: rgba(0, 0, 0, 0.2);
    box-shadow: inherit;
    border-bottom: 3px solid @fg-color;
}

#workspaces button.focused {
    background-color: @bg-color;
    border-bottom: 3px solid @fg-color;
}

#workspaces button.urgent {
    background-color: @alert-bg-color;
}

#mode {
    padding: 0 10px;
    margin: 0 4px;
    background-color: @bg-color;
    border-bottom: 3px solid @fg-color;
}

#clock {
    padding: 0 10px;
    margin: 0 0px;
    background-color: rgba(0,0,0,0);
    color: @fg-color;
}

@keyframes blink {
    to {
        background-color: @fg-color;
        color: @bg-color;
    }
}

label:focus {
    background-color: @bg-color;
}

#network.disconnected {
    background-color: @alert-bg-color;
}

#custom-vpn.disconnected {
    background-color: @alert-bg-color;
}

#pulseaudio.muted {
    background-color: @inactive-bg-color;
    color: @inactive-fg-color;
}

#custom-media.custom-vlc {
    background-color: @bg-color;
}

#temperature.critical {
    background-color: @alert-bg-color;
}

#idle_inhibitor.activated {
    background-color: @fg-color;
    color: @bg-color;
}

#mpd.disconnected {
    background-color: transparent;
    color: transparent;
}

#mpd.stopped {
    background-color: transparent;
    color: transparent;
}

#mpd.paused {
    background-color: @inactive-bg-color;
    color: @inactive-fg-color;
}

     ''
    ];
  };
}

