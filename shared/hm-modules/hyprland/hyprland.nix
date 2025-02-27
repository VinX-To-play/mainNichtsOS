{
  imports = [
    ./waybar.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;
    systemd.variables = ["--all"];
    settings = {
      general = {
        gaps_in = 0;
        gaps_out = 0;
      };

      input = {
	natural_scroll = true;
      };

      "$mod" = "SUPER";
      bind = 
      [
        # Windows managment
        "ALT, Tap, cyclenext"
        "SHIFT, ALT, cyclenext, priv"
        "$mod, q, killactive"
        "$mod, F, fullscreen"
        "$mod shift, F, togglefloating"

        
        # moving 
        "$mod,left,movefocus,l"
	"$mod,right,movefocus,r"
	"$mod,up,movefocus,u"
	"$mod,down,movefocus,d"
	"$mod,K,movefocus,u"
	"$mod,J,movefocus,d"
	"$mod,H,movefocus,l"
	"$mod,L,movefocus,r"

        # Workspaces
	"$mod,1,workspace,1"
	"$mod,2,workspace,2"
	"$mod,3,workspace,3"
	"$mod,4,workspace,4"
	"$mod,5,workspace,5"
	"$mod,6,workspace,6"
	"$mod,7,workspace,7"
	"$mod,8,workspace,8"
	"$mod,9,workspace,9"

	"$modSHIFT,1,movetoworkspacesilent,1"
	"$modSHIFT,2,movetoworkspacesilent,2"
	"$modSHIFT,3,movetoworkspacesilent,3"
	"$modSHIFT,4,movetoworkspacesilent,4"
	"$modSHIFT,5,movetoworkspacesilent,5"
	"$modSHIFT,6,movetoworkspacesilent,6"
	"$modSHIFT,7,movetoworkspacesilent,7"
	"$modSHIFT,8,movetoworkspacesilent,8"
	"$modSHIFT,9,movetoworkspacesilent,9"

        # applications
        "$mod, B, exec, firefox"
        "$mod, O, exec, obsidian"
        "$mod, T, exec, kitty"
        "$mod,E,exec, dolphin"
      ];
      bindl = [
        #Audio & monitor
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set '5%+'"
        ", XF86MonBrightnessDown, exec, brightnessctl set '5%-'"
      ];

      
      bindm = [
	# mouse movements
	"$mod, mouse:272, movewindow"
	"$mod, mouse:273, resizewindow"
	"$mod ALT, mouse:272, resizewindow"
      ];
      
      monitor = [
        ",highres,auto,1"
      ];
    };
      extraConfig = ''
	exec-once = waybar
	'';
  };
}
