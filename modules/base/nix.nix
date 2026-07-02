{ ... }: {
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "vincentl" ];
    substituters = [
      "https://nix.slave.int"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "vincent-cache-1:9r9bePSUWsLD4yHr7VA0WOEda71CQNbLngUYBkBgcsM="
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
    ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nixpkgs.config = {
    permittedInsecurePackages = [ "libxml2-2.13.8" ];
    allowUnfree = true;
  };

}
