{...}:{
  flake.homeModules.Desktop = {...}:{
    programs.nixvim = {
      wrapRc = false;
      extraConfigLua = ''
        vim.o.exrc = true
        vim.o.secure = true 
      '';
    };
  };
}
