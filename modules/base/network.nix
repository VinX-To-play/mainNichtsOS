{config, inputs, ...}: {
  flake.nixosModules.base = {...}: {
    imports = [ inputs.sheard-host.nixosModules.sheardHosts ];
      networking = {
        networkmanager.enable = true;
        nameservers = [ "1.1.1.1" "1.0.0.1"];
        firewall.enable = true;
    };
  };
}
