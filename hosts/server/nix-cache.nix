{ config, pkgs, ... }:
{
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/etc/nix/secret-key.pem";
  };

  services.nginx.virtualHosts."nix.slave.int" = {
      locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
  };

  systemd.services.nixos-auto-update = {
    description = "update flake, build for all systems";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      WorkingDirectory = "/home/vincentl/mainNichtsOS/";
    };
    script = ''
      #!/usr/bin/env bash
      set -e # Exit immediately if any command fails
      
      # The hostname of this server as defined in the flake
      SERVER_HOSTNAME="nix-server"
      
      cd /home/vincentl/mainNichtsOS/
      
      echo "=== Updating flake.lock ==="
      nix flake update
      
      echo "=== Building all systems ==="
      # This ensures that specific outputs are built and cached locally.
      # We build the top-level system closures for all hosts you manage.
      # Adjust the list of hostnames below.
      nix build ".#nixosConfigurations.$SERVER_HOSTNAME.config.system.build.toplevel" \
                ".#nixosConfigurations.nichtsos.config.system.build.toplevel" \
                ".#nixosConfigurations.nichtsos-thinkpad-T14.config.system.build.toplevel" \
                ".#nixosConfigurations.nichtsos-thinkpad.config.system.build.toplevel" \
                --accept-flake-config
      
      echo "=== Builds successful. Switching local system ==="
      nixos-rebuild switch --flake ".#$SERVER_HOSTNAME"
      
      echo "=== Push to git ==="
      git add flake.lock
      git commit -m "updated flake inputes"
      git push
      
      echo "=== Done! ==="
    '';
  };
  
  systemd.timers.nixos-auto-update = {
    description = "Run auto-update nightly";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "04:00"; # Runs at 4 AM
      Persistent = true;
      Unit = "nixos-auto-update.service";
    };
  };
}
