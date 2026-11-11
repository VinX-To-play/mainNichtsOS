{...}:{
  flake.homeModules.Desktop = {...}:{
    programs.neovim.sideloadInitLua = true;

    programs.nixvim = {
      extraConfigLua = ''
        vim.o.exrc = true
        vim.o.secure = true 
      '';
    };
  };
}
