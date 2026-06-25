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
        qwen36-35B-A3B = builtins.fetchurl {
          url = "https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-UD-IQ2_M.gguf?download=true";
          sha256 = "sha256:0hrx82chg9i3rr75nrsdnvfxaavckb7h54c2sc88pbz1swgfzrrb";
        };
        gemma-4-12B = {
          model = builtins.fetchurl {
            url = "https://huggingface.co/HauhauCS/Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced/resolve/main/Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M.gguf?download=true";
            sha256 = "sha256:0d2ibdwcp4dsrjzlfvgc29zxjv71l97bc84ygslnqdynjis6srar";
            };
          decoder = builtins.fetchurl {
            url = "https://huggingface.co/HauhauCS/Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced/resolve/main/mtp-gemma-4-12B-it.gguf?download=true";
            sha256 = "sha256:1d0h4dfz13vv1b1lh1x0387fwnwcijxhr4z8n8aki404bz1r2365";
            };
          mmproj = builtins.fetchurl {
            url = "https://huggingface.co/HauhauCS/Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced/resolve/main/mmproj-Gemma4-12B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf?download=true";
            sha256 = "sha256:13mbfs96yq4c2hh33inb5c4ni8q4q626g7njbdkg1rdpg5a837mm";
            };
        };
      in
      {
        globalTTL = 300;
        healthCheckTimeout = 60;
        models = {
          "gemma-4-E4B" = {
            cmd = "${llama-server} -m ${gemma-4-E4B} ${stand-arg} --ctx-size 32768 --jinja";
          };

          "gemma-4-12B" = {
            cmd = "${llama-server} ${stand-arg}
                    -m ${gemma-4-12B.model}
                    -md ${gemma-4-12B.decoder}
                    -mmproj ${gemma-4-12B.mmproj}
                    -spec-type draft-mtp
                    -ngl 99
                    -fa on
                    --ctx-size 262144
                    --jinja";
            filter = {
              stripParams = "temperature, top_p, min_p, top_k, repeat_penalty";
              setParams = {
                temperature = 0.6;
                top_p = 0.9;
                top_k = 64;
                min_p = 0.05;
                repeat_penalty = 1.1;
              };
            };
          };

          "GPTOSS-20B" = {
            cmd = "${llama-server} -m ${gptoss-20b} ${stand-arg}";
            name = "gpt-oss 20B";
          };

          "Qwen3.6-35B-A3B" = {
            cmd = "${llama-server} -m ${qwen36-35B-A3B} ${stand-arg} --ctx-size 65536 --jinja";
          };
        };
      };
    };
}
