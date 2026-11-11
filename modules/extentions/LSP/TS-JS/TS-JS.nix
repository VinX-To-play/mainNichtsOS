{ ... }: {
  flake.homeModules.ts-js = { ... }: {
    programs.nixvim = {
      plugins.typescript-tools.enable = true;

      extraConfigLua = ''
        require("typescript-tools").setup {
          handlers = {
            ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
              if vim.fn.getcwd():find("cryptid-reserv", 1, true) then
                return require("typescript-tools.api").filter_diagnostics({
                  7006, 7031, 7053, 7005,
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
