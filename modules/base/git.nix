{...}: {
  flake.homeModules.base = {...}: {
    programs.git = {
      enable = true;
      settings = {
        user = {
          email = "v@lundborgs.de";
          name = "VinX-To-play";
        };
        pull = {
          rebase = true;
          autoSetupRemote = true;
        };
      };
    };
  };
}
