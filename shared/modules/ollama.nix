{pkgs, ...}:

{
  services.ollama = {
    enable = false;
    package = pkgs.ollama.override{ enableCuda=true; };
    acceleration = "cuda";
  };
}
