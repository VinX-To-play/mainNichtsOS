{ ... }: {
  flake.homeModules.ts-js = { ... }: {
    programs.nixvim.plugins.typescript-tools = {
      enable = true;
    };
  };
}
