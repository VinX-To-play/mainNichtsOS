{ ... }: {
  flake.homeModules.cpp = { ... }: {
    programs.nixvim.plugins.lsp.servers.qmlls = {
      enable = true;
      extraOptions = {
        # Use __raw to inject Lua code. This allows us to read the 
        # QML_IMPORT_PATH environment variable (set by your Nix flake) 
        # at runtime, and dynamically append the local /build directory.
        cmd.__raw = ''
          { 
            "qmlls", 
            "-I", os.getenv("QML_IMPORT_PATH") or "", 
            "-I", vim.fn.getcwd() .. "/build" 
          }
        '';
      };
    };
  };
}
