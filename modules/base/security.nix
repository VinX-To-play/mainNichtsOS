{
flake.modules.nixos.base.security = {pkgs, ...}:{
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  security.polkit.enable = true;

  system.extraDependencies = [pkgs.sops pkgs.age];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSops.Format = "yaml";
    age.keyFile = "/home/vincentl/.config/sops/age/keys.txt";
  };
};
}
