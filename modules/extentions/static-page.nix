{config, ... }: {

  flake.nixosModules.static-webpage = 
    { config,pkgs, ... }:
let 
  hostInter = "ens18";
  tunnelId = "c836e33f-eafa-449d-8930-63c0538c4ef8";
  tunnelServiceName = "cloudflared-tunnel-${tunnelId}";

  staticFiles = fetchGit {
        url = "git@github.com:VinX-To-play/elin-webpage.git";
        ref = "main";
        rev = "d6b7eb7e519a47e22649e2f5ed7250f2375ab1a9";
        lfs = true;
    };
in
{

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = hostInter;
    enableIPv6 = false;
  };

  users.users.cf-tunnel = {
    uid = 980;
    group = "cf-tunnel";
    isSystemUser = true;
    };
  users.groups.cf-tunnel = {
    gid = 980;
  };
  # 1. Strictly 0400 on the host
  sops.secrets."cloudflare.pam" = {
    sopsFile = ../../secrets/cloudflare/cert.pem;
    format = "binary";
    mode = "0400"; 
    owner = "cf-tunnel";
    group = "cf-tunnel";
  };

  sops.secrets."${tunnelId}.json" = {
    sopsFile = ../../secrets/cloudflare/${tunnelId}.json;
    format = "binary";
    mode = "0400"; 
    owner = "cf-tunnel";
    group = "cf-tunnel";
  };
  
  containers.webserver = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.1.205";
    localAddress = "192.168.1.206";
    
    # 2. Bind mount to a hidden staging directory, NOT the final paths
    bindMounts = {
      "/run/host-secrets/pam" = {
        hostPath = config.sops.secrets."cloudflare.pam".path;
        isReadOnly = true;
      };
      "/run/host-secrets/tunnel" = {
        hostPath = config.sops.secrets."${tunnelId}.json".path;
        isReadOnly = true;
      };
      "/webpage" = {
        hostPath = "${staticFiles}/";
        isReadOnly = true;
      };
    }; 
    
    config = { config, pkgs, lib, ... }: {
      # user for secrets of couldflare
      users.users.cloudflared = {
          uid = 980;
          group = "cloudflared";
          isSystemUser = true;
        };
      users.groups.cloudflared = {
          gid = 980;
        };

    
      services.nginx = {
        enable = true;
        virtualHosts."_" = {
          locations."/" = {
            root = "/webpage";
            index = "index.html";
          };
        };
      };
    
      services.cloudflared = {
        enable = true;
        
        # Point DIRECTLY to the bind mounts. No symlinks needed.
        certificateFile = "/run/host-secrets/pam";
        
        tunnels.${tunnelId} = {
          credentialsFile = "/run/host-secrets/tunnel";
          ingress = {
            "elin.love" = "http://localhost:80";
          };
          default = "http_status:404";
        };
      };

      # Override the NixOS module to disable DynamicUser and run as root
      systemd.services.${tunnelServiceName} = {
        serviceConfig = {
          DynamicUser = lib.mkForce false;
          User = lib.mkForce "cloudflared";
          Group = lib.mkForce "cloudflared";
        };
      };

      networking = {
        firewall.allowedTCPPorts = [  ];
        useHostResolvConf = lib.mkForce false;
      };
      
      services.resolved.enable = true;
      system.stateVersion = "26.05";
    };
  };
};
}
