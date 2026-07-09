{ ...}: {
flake.nixosModules.security = {inputs, pkgs, ...}: {

  imports = [ inputs.sops-nix.nixosModules.sops ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  security.polkit.enable = true;

  system.extraDependencies = [pkgs.sops pkgs.age];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/vincentl/.config/sops/age/keys.txt";
  };
};
}
