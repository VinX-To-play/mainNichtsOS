{ ... }: {
  services.step-ca = {
    enable = true;
    settings = builtins.fromJSON( builtins.readFile ./ca.json );
    address = "127.0.0.1";
    port = 8443;
    intermediatePasswordFile = "/var/lib/secrets/step-ca/intermediate_password";
  };
  
  networking.firewall.allowedTCPPorts = [ 8443 ];
}
