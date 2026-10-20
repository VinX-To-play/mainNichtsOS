{...}:
{
  flake.nixosModules.monitoring-host = {pkgs, ...}:{
    vinlabs.prometheus-exporters = [ 
        "192.169.1.1:5005"
    ];
  };
}
