{...}:{
  flake.homeModules.Desktop = {...}:{
    programs.nixvim = {
      extraConfigLua = ''
        vim.o.exrc = true
        vim.o.secure = true 
      '';
    };
  };
}
