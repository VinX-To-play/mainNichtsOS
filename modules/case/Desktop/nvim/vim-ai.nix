{...}: {
  flake.nixosModules.Desktop = {...}: {
    sops.secrets."llm-apiKey/deepseek" = {
      owner = "vincentl";
    };
  };

  flake.homeModules.Desktop = {pkgs, ...}: {
    programs.nixvim = {
      extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
        name = "vim-ai";
        src = pkgs.fetchFromGitHub {
          owner = "madox2";
          repo = "vim-ai";
          rev = "f46c2343a7d81c74ab249214ed9d0a9c6edac07f";
          hash = "sha256-tMXlrZRv7B94TwE7YkNqxYDRWQUFdMNvHa6vle95EsE=";
        };
      })];

      extraConfigVim = ''
        let g:vim_ai_chat = {
        \ 'engine': 'chat',
        \ 'provider': 'openai',
        \ 'options': {
        \   'model': 'deepseek-v4-flash',
        \   'endpoint_url': 'https://api.deepseek.com/v1/chat/completions',
        \   'enable_auth': 1,
        \   'token_file_path': '/run/secrets/llm-apiKey/deepseek',
        \   'max_tokens': 0,
        \   'request_timeout': 60,
        \   },
        \ }
        
        let g:vim_ai_edit = g:vim_ai_chat
        let g:vim_ai_complete = g:vim_ai_chat
      '';
    };
  };
}
