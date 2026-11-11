{ ... }: {
  flake.homeModules.ts-js = { ... }: {
    programs.nixvim = {
      plugins.typescript-tools.enable = true;

      extraConfigLuaPost = ''
        require("typescript-tools").setup {
          handlers = {
            ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
              -- Check both the current file path and the current working directory
              local current_path = vim.api.nvim_buf_get_name(0) .. vim.fn.getcwd()
              
              if current_path:find("cryptid%-reserve") then
                return require("typescript-tools.api").filter_diagnostics({
                  7044, -- Parameter implicitly has an 'any' type
                  7043, -- Variable implicitly has an 'any' type
                  7031, -- Binding element implicitly has an 'any' type
                  7006, -- (Older TS versions use this for parameters)
                })(err, result, ctx, config)
              end
              
              -- Default behavior for all other projects
              vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            end,
          },
        }
      '';
    };
  };
}
