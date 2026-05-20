{self, inputs, lib, pkgs, config, ... }: {

    services.llama-swap = {
      enable = true;
      port = 11343;
      listenAddress = "${(builtins.head config.networking.interfaces.enp7s0.ipv4.addresses).address}";
      openFirewall = true;
      settings = 
      let
        llama-cpp = pkgs.llama-cpp.override { rocmSupport = true; };
        llama-server = lib.getExe' llama-cpp "llama-server";
        stand-arg = " --no-webui --main-gpu 0 --port \${PORT}";
        
        gemma-4-E4B = builtins.fetchurl {
          url = "https://huggingface.co/mradermacher/gemma-4-E4B-GGUF/resolve/main/gemma-4-E4B.Q8_0.gguf?download=true";
          sha256 = "sha256:03wi3ffv5xsd22fc27g27ckfx8mcy79ahigsna3k2mhhqjdxjiiy";
        };

        gptoss-20b = builtins.fetchurl {
          url = "https://huggingface.co/unsloth/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-Q4_K_M.gguf?download=true";
          sha256 = "sha256:0kzbi9bc1k7qka8padg9nn6qzf881bc831y6bn3340211rj3cxf2";
        };
      test-modle = builtins.fetchurl {
        url = "https://huggingface.co/MaziyarPanahi/gemma-3-1b-it-GGUF/resolve/main/gemma-3-1b-it.Q4_K_M.gguf?download=true";
        sha256 = "sha256:1hnyz2ksrs5rpwac4z4r3q3npy0g0hf8bhfsalbn562id20l4c74";
      };
      in
      {
        globalTTL = 300;
        healthCheckTimeout = 60;
        models = {
          "gemma-4-E4B" = {
            cmd = "${llama-server} -ngl 0 -m ${gemma-4-E4B} ${stand-arg}";
            name = "gemma 4";
          };
          "GPTOSS-20B" = {
            cmd = "${llama-server} -m ${gptoss-20b} ${stand-arg}";
            name = "gpt-oss 20B";
          };
          "test-model" = {
            cmd = "${llama-server} -m ${test-modle} ${stand-arg}";
          };
        };
      };
    };
}
