{...}: {
  flake.nixosModules.gaming = {pkgs, ...}:{
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          OBS_VKCAPTURE = true;
        };
        extraLibraries = p: with p; [
          usbutils
        ];
      };
      gamescopeSession.enable = true;
    };
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}
