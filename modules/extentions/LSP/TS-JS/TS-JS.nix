{ ... }: {
  flake.homeModules.ts-js = { ... }: {
    programs.nixvim = {
      plugins = {
        typescript-tools.enable = false;
        lsp.servers.ts_ls = {
          enable = true;
          settings = {
            diagnostics = {
              ignoredCodes = [
                7044 #any 
                7043 #any
                6385 #'name' is depricated
              ];
            };
          };
        };
      };
    };
  };
}
