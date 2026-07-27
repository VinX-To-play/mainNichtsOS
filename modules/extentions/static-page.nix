{... }: {

  flake.nixosModules.static-webpage = {...}:{
    networking.nat = {
      enable = true;
      # Use "ve-*" when using nftables instead of iptables
      internalInterfaces = ["ve-+"];
      externalInterface = "ens3";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = false;
      
    };
    
    containers.webserver = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.1.206";
      localAddress = "192.168.100.11";
      config = { config, pkgs, lib, ... }: {
    
        services.httpd = {
          enable = true;
          adminAddr = "admin@example.org";
        };
    
        networking = {
          firewall.allowedTCPPorts = [ 80 ];
    
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };
        
        services.resolved.enable = true;
    
        system.stateVersion = "26.05";
      };
    };
    };
}
