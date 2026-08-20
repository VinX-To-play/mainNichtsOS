{config, inputs, lib, ...}: {
  flake.nixosModules.base = {...}: {
    imports = [ inputs.sheard-host.nixosModules.sheardHosts ];
      networking = {
        networkmanager.enable = true;
        nameservers = lib.mkDefault [ "1.1.1.1" "1.0.0.1"];
        firewall.enable = true;

      hosts = {
        "192.168.1.2" = [ 
          "main.int"
        ];
      };
    };
  };
}
