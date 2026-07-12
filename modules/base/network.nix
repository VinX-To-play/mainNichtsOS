{config, ...}: {
  flake.nixosModules.base = {...}: {
      networking = {
        networkmanager.enable = true;
        nameservers = [ "1.1.1.1" "1.0.0.1"];
        firewall.enable = true;
    };
  };
}
