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
        position = "top";
        spacing = 5;

        modules-left = [
	  "hyprland/workspaces" 
	];
        modules-center = [ 
	  "hyprland/window"
	];
        modules-right = [
          "cpu"
          "network"
	  "pulseaudio"
          "backlight"
          "battery"
	  "tray"
          "clock"
          "custom/powerwidgit"
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

        "pulseaudio" = {
          format = "{icon}{volume}% {format_source}";
          format-bluetooth = "{icon} {volume}% {format_source}";
          format-bluetooth-muted = "{icon} 🔇 {format_source}";
          format-muted = "🔇 {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };

	"hyprland/window" = {
          max-length = 22;
          separate-outputs = false;
          rewrite = {
            "" = " No Window? ";
          };
	};

	"clock" = {
	  format = "{:%H:%M | %A %e %b}";
          tooltip = true;  
          tooltip-format = "<big>{:%A, %d.}</big>\n<tt><big>{calendar}</big></tt>";
	  on-click = "gnome-calendar";
	};

	"tray" = {
	  spacing = 3;
	};

        "custom/powerwidgit" = {
          format = "⏻  ";
          on-click = "/home/vincentl/.config/eww/powerwidgit.sh";
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
          on-click = "nm-connection-editor";
        };

        "battery" = {
	  interval = 60;
	  states = {
	    warning = 30;
	    critical = 15;
	    };
	  format = "{capacity}% {icon}";
	  format-icons = ["" "" "" "" ""];
	  max-length = 25;
        };

        "cpu" = {
          format = "{usage}% ";
          tooltip = false;
          on-click = "kitty btop";
        };

        "backlight" = {
          format = "{percent}% {icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
          tooltip = false;
          on-click = ./../../scripts/click-brightnis.sh;
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
    border-bottom: none;
    color: @fg-color;
    transition-property: background-color;
    transition-duration: .5s;
}

window#waybar.hidden {
    opacity: 0.4;
}

#clock {
    padding: 0 10px;
    margin: 0 0px;
    background-color: rgba(0,0,0,0);
    color: @fg-color;
}

     ''
    ];
  };
}

