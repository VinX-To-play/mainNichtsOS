{...}: {
  flake.nixosModules.Desktop = {...}: {
    sops.secrets."llm-apiKey/deepseek" = {
      owner = "vincentl";
      path = "/var/lib/llm/deepseek";
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
        let g:vim_ai_token_file_path = '/var/lib/llm/deepseek'

        let g:vim_ai_chat = {
        \ 'options': {
        \   'model': 'deepseek-v4-flash',
        \   'endpoint_url': 'https://api.deepseek.com/v1/chat/completions',
        \   'auth_type': 'api-key',
        \   },
        \ }

        let g:vim_ai_complete = {
        \ 'options': {
        \   'model': 'deepseek-v4-flash',
        \   'endpoint_url': 'https://api.deepseek.com/v1/chat/completions',
        \   'auth_type': 'api-key',
        \   },
        \ }

        let g:vim_ai_edit = {
        \ 'options': {
        \   'model': 'deepseek-v4-flash',
        \   'endpoint_url': 'https://api.deepseek.com/v1/chat/completions',
        \   'auth_type': 'api-key',
        \   },
        \ }
      '';
    };
  };
}
