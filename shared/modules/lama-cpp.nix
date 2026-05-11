{self, inputs, lib, pkgs, ... }: {

    services.llama-swap = {
      enable = true;
      port = 11343;
      settings = 
      let
        llama-cpp = pkgs.llama-cpp.override { rocmSupport = true; };
        llama-server = lib.getExe' llama-cpp "llama-server";
        
        gemma-4-E4B = builtins.fetchurl {
          url = "https://huggingface.co/mradermacher/gemma-4-E4B-GGUF/resolve/main/gemma-4-E4B.Q8_0.gguf?download=true";
          sha256 = "sha256:03wi3ffv5xsd22fc27g27ckfx8mcy79ahigsna3k2mhhqjdxjiiy";
        };

        gptoss-20b = builtins.fetchurl {
          url = "https://huggingface.co/unsloth/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-Q4_K_M.gguf?download=true";
          sha256 = "sha256:0kzbi9bc1k7qka8padg9nn6qzf881bc831y6bn3340211rj3cxf2";
        };
      in
      {
        globalTTL = 300;
        healthCheckTimeout = 60;
        models = {
          "gemma-4-E4B" = {
            cmd = "${llama-server} --port \${PORT} -m ${gemma-4-E4B} -ngl 0 --no-webui";
            name = "gemma 4";
          };
          "GPTOSS-20B" = {
            cmd = "${llama-server} --port \${PORT} -m ${gptoss-20b} -ngl 0 --no-webui";
            name = "gpt-oss 20B";
          };
        };
      };
    };
}
