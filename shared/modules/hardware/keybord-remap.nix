{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.vinlabs.keyboard;
in {
  options.vinlabs.keyboard = {
    enable = mkEnableOption "Custom KMonad configuration for qwerty";
    device = mkOption {
      type = types.str;
      default = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      description = "The input device path for the keyboard.";
    };
  };

  config = mkIf cfg.enable {
    services.kmonad = {
      enable = true;
      keyboards = {
        internal-kbd = {
          device = cfg.device;
          config = ''
          (defcfg
            input  (device-file "${cfg.device}")
            output (uinput-sink "kmonad-output")
            fallthrough true
            allow-cmd false
          )

          ;; The source keys we want to intercept
          (defsrc
            caps wkup
            h    j    k    l
            left right
          )

          (defalias
            ;; Fn key (wkup) triggers the 'navigation' layer
            fn (layer-toggle nav)
          )

          (deflayer default
            bspc @fn
            h    j    k    l
            left right
          )

          (deflayer nav
            _    _
            left down up   right
            prev next
          )
           '';
        };
      };
    };
  };
}
