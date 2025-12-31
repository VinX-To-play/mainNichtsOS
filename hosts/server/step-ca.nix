{ ... }: {
  services.step-ca = {
    enable = true;
    settings = builtins.fromJSON( builtins.readFile ./ca.json );
    address = "0.0.0.0";
    port = 8443;
    intermediatePasswordFile = "/var/lib/secrets/step-ca/intermediate_password";
  };
  
  networking.firewall.allowedTCPPorts = [ 8443 ];
}
