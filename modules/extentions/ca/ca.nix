{config,...}:{
  flake.nixosModules.ca = {...}:{
    services.step-ca = {
      enable = true;
      settings = builtins.fromJSON( builtins.readFile ./ca.json );
      address = "0.0.0.0";
      port = 8443;
      intermediatePasswordFile = "/var/lib/secrets/step-ca/intermediate_password";
    };
    networking.firewall.allowedTCPPorts = [ config.services.step-ca.port ];
  };
}
